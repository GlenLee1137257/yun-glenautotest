package com.glen.autotest.util;

import com.glen.autotest.enums.BizCodeEnum;
import com.glen.autotest.enums.SeleniumByEnum;
import com.glen.autotest.enums.SeleniumWebDriverEnum;
import com.glen.autotest.exception.BizException;
import lombok.extern.slf4j.Slf4j;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.chrome.ChromeOptions;
import org.openqa.selenium.safari.SafariDriver;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;

import java.time.Duration;

/**
 * Glen AutoTest Platform
 *
 * @Description
 * @Author Glen Team
 * @Remark Glen AutoTest Platform
 * @Version 1.0
 **/
@Slf4j
public class SeleniumFetchUtil {

    public static WebDriver getWebDriver(String driverName) {
        return getWebDriver(driverName, null);
    }

    public static WebDriver getWebDriver(String driverName, Integer headlessMode) {

        //获取系统类型
        String osName = System.getProperty("os.name").toLowerCase();
        SeleniumWebDriverEnum seleniumWebDriverEnum = SeleniumWebDriverEnum.valueOf(driverName);
       return switch (seleniumWebDriverEnum){
            case CHROME -> {
                ChromeOptions options = new ChromeOptions();
                //--no-sandbox参数表示禁用沙箱模式，以提高浏览器的兼容性和稳定性。
                //--disable-dev-shm-usage参数表示禁用/dev/shm的使用，以避免在某些Linux系统中出现的内存不足问题。
                //--disable-extensions参数表示禁用所有扩展，以防止扩展影响浏览器的性能和稳定性。
                options.addArguments("--no-sandbox");
                options.addArguments("--disable-dev-shm-usage");
                options.addArguments("--disable-extensions");
                // 允许远程连接（WSL2环境需要）
                options.addArguments("--remote-allow-origins=*");

                // 自动检测 Chrome 二进制路径
                String chromeBinaryPath = System.getenv("CHROME_BINARY_PATH");
                if (chromeBinaryPath == null || chromeBinaryPath.isEmpty()) {
                    // 尝试常见的 Chrome 安装路径
                    String[] chromePaths = {
                        "/usr/bin/google-chrome",
                        "/usr/bin/chrome",
                        "/usr/bin/chromium-browser",
                        "/usr/bin/chromium",
                        "/snap/bin/chromium"
                    };
                    for (String path : chromePaths) {
                        java.io.File chromeFile = new java.io.File(path);
                        if (chromeFile.exists() && chromeFile.canExecute()) {
                            chromeBinaryPath = path;
                            break;
                        }
                    }
                }
                
                if (chromeBinaryPath != null && !chromeBinaryPath.isEmpty()) {
                    options.setBinary(chromeBinaryPath);
                }

                // 关闭密码管理器和密码泄露检测弹窗，避免打断自动化流程
                java.util.Map<String, Object> prefs = new java.util.HashMap<>();
                // 关闭 Chrome 自带的密码保存提示 & 密码管理器
                prefs.put("credentials_enable_service", false);
                prefs.put("profile.password_manager_enabled", false);
                // 关闭网页通知，避免额外弹窗
                prefs.put("profile.default_content_setting_values.notifications", 2);
                options.setExperimentalOption("prefs", prefs);
                // 显式关闭密码泄露检测等特性及保存密码气泡
                options.addArguments(
                        "--disable-features=PasswordLeakDetection,PasswordManagerOnboarding,NotificationTriggers");
                options.addArguments("--disable-save-password-bubble");
                // 使用 basic 密码存储方式，避免调用 Google Password Manager
                options.addArguments("--password-store=basic");

                // 为自动化创建一个单独的用户数据目录，避免复用你平时浏览产生的密码/缓存数据
                String userHome = System.getProperty("user.home");
                String autoProfileDir = userHome + "/.glenautotest/chrome-profile";
                options.addArguments("--user-data-dir=" + autoProfileDir);

                // 优先从环境变量读取ChromeDriver路径
                String chromeDriverPath = System.getenv("CHROME_DRIVER_PATH");

                if (chromeDriverPath == null || chromeDriverPath.isEmpty()) {
                    // 尝试常见的 ChromeDriver 安装路径（复用上面的 userHome 变量）
                    String[] driverPaths = {
                        userHome + "/chromedriver/chromedriver-linux64/chromedriver",
                        "/usr/local/bin/chromedriver",
                        "/usr/bin/chromedriver"
                    };
                    
                    for (String path : driverPaths) {
                        java.io.File driverFile = new java.io.File(path);
                        if (driverFile.exists() && driverFile.canExecute()) {
                            chromeDriverPath = path;
                            log.info("找到 ChromeDriver: {}", path);
                            break;
                        }
                    }
                }
                
                // 设置 ChromeDriver 路径（如果找到）
                if (chromeDriverPath != null && !chromeDriverPath.isEmpty()) {
                    System.setProperty("webdriver.chrome.driver", chromeDriverPath);
                    log.info("设置 ChromeDriver 路径: {}", chromeDriverPath);
                } else {
                    log.warn("未找到本地 ChromeDriver，Selenium 将尝试使用 Selenium Manager 自动管理");
                    // 如果未找到本地 ChromeDriver，Selenium 4.x 会尝试使用 Selenium Manager 自动下载
                    // 但在 WSL2 环境中可能会失败
                }

                // 判断是否使用无头模式
                // 优先级：用户选择 > 环境变量 UI_HEADLESS_MODE > 检测 DISPLAY 环境变量 > 默认规则
                boolean useHeadless = false;
                
                if (headlessMode != null) {
                    // 1. 用户在前端选择（最高优先级）
                    // headlessMode = 0 表示显示窗口，1 表示无头模式
                    useHeadless = (headlessMode == 1);
                } else {
                    // 2. 环境变量控制
                    String headlessModeEnv = System.getenv("UI_HEADLESS_MODE");
                    if (headlessModeEnv != null && !headlessModeEnv.isEmpty()) {
                        useHeadless = "true".equalsIgnoreCase(headlessModeEnv) || "1".equals(headlessModeEnv);
                    } else {
                        // 3. 自动检测图形界面
                        String display = System.getenv("DISPLAY");
                        if (display == null || display.isEmpty()) {
                            // 没有 DISPLAY 环境变量，使用无头模式
                            useHeadless = true;
                        } else {
                            // 有 DISPLAY 环境变量，说明有图形界面，不使用无头模式
                            useHeadless = false;
                        }
                    }
                }
                
                if (useHeadless) {
                    options.addArguments("--headless");
                }

                System.setProperty("webdriver.chrome.logfile", "./chromedriver.log");
                try {
                    // 记录配置信息用于调试
                    log.info("初始化 Chrome WebDriver - Chrome路径: {}, ChromeDriver路径: {}, 无头模式: {}", 
                        chromeBinaryPath != null ? chromeBinaryPath : "自动检测",
                        System.getProperty("webdriver.chrome.driver") != null ? System.getProperty("webdriver.chrome.driver") : "Selenium Manager自动管理",
                        useHeadless);
                    
                    WebDriver webDriver = new ChromeDriver(options);
                    if (!useHeadless) {
                        // 如果有图形界面，最大化窗口以便用户观察
                        webDriver.manage().window().maximize();
                    }
                    log.info("Chrome WebDriver 初始化成功");
                yield webDriver;
                } catch (Exception e) {
                    // 捕获驱动初始化异常，提供更友好的错误信息
                    log.error("Chrome WebDriver 初始化失败", e);
                    String errorMsg = e.getMessage();
                    if (errorMsg != null && (errorMsg.contains("chromedriver") || 
                        errorMsg.contains("ChromeDriver") || 
                        errorMsg.contains("NoSuchDriverException") ||
                        errorMsg.contains("Unable to obtain") ||
                        errorMsg.contains("chromedriver version cannot be discovered"))) {
                        throw new BizException(BizCodeEnum.UI_DRIVER_INIT_FAILED);
                    }
                    // 如果是其他异常，也提供详细的错误信息
                    log.error("Chrome WebDriver 初始化失败，异常类型: {}, 异常信息: {}", e.getClass().getName(), errorMsg);
                    throw e;
                }
            }
            case SAFARI -> {
                WebDriver webDriver = new SafariDriver();
                //webDriver.manage().window().maximize();
                yield webDriver;
            }
            default -> {
                throw new BizException(BizCodeEnum.UI_UNSUPPORTED_BROWSER_DRIVER);
            }
        };
    }


    /**
     * 查找UI元素
     * @param locationType
     * @param locationExpress
     * @param waitTime
     * @return
     */
    public static WebElement findElement(String locationType,String locationExpress,Long waitTime) {
        WebDriver webDriver = SeleniumWebdriverContext.get();
        //配置元素等待时间
        WebDriverWait wait = new WebDriverWait(webDriver, Duration.ofMillis(waitTime));

        SeleniumByEnum seleniumByEnum = SeleniumByEnum.valueOf(locationType);
        return switch (seleniumByEnum){

            case XPATH -> wait.until(ExpectedConditions.presenceOfElementLocated(By.xpath(locationExpress)));

            case TAG_NAME ->
                wait.until(ExpectedConditions.presenceOfElementLocated(By.tagName(locationExpress)));
            case ID ->
                wait.until(ExpectedConditions.presenceOfElementLocated(By.id(locationExpress)));
            case NAME ->
                wait.until(ExpectedConditions.presenceOfElementLocated(By.name(locationExpress)));
            case CLASS_NAME ->
                wait.until(ExpectedConditions.presenceOfElementLocated(By.className(locationExpress)));
            case LINK_TEXT ->
                wait.until(ExpectedConditions.presenceOfElementLocated(By.linkText(locationExpress)));
            case CSS_SELECTOR ->
                wait.until(ExpectedConditions.presenceOfElementLocated(By.cssSelector(locationExpress)));
            case PARTIAL_LINK_TEXT ->
                    wait.until(ExpectedConditions.presenceOfElementLocated(By.partialLinkText(locationExpress)));

            default -> throw new BizException(BizCodeEnum.UI_ELEMENT_NOT_EXIST);
        };

    }


}
