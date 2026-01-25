-- ============================================
-- 删除性能测试断言来源中的"响应时间"选项
-- ============================================
-- 说明：RESPONSE_TIME 在前端显示，但后端代码不支持
-- 执行此SQL后，前端将不再显示"响应时间"选项
-- ============================================

-- 方式1：基于ID删除（推荐，最精确）
DELETE FROM `sys_dict` 
WHERE `id` = 223 
  AND `category` = 'stress_assert_from' 
  AND `value` = 'RESPONSE_TIME';

-- 方式2：基于分类和值删除（更安全，即使ID变化也能删除）
-- DELETE FROM `sys_dict` 
-- WHERE `category` = 'stress_assert_from' 
--   AND `value` = 'RESPONSE_TIME';

-- ============================================
-- 验证删除结果（可选执行）
-- ============================================
-- SELECT * FROM `sys_dict` 
-- WHERE `category` = 'stress_assert_from';
