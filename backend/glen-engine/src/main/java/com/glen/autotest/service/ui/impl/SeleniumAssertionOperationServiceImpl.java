package com.glen.autotest.service.ui.impl;

import com.glen.autotest.dto.UiOperationResultDTO;
import com.glen.autotest.service.ui.SeleniumAssertionOperationService;
import com.glen.autotest.util.SeleniumFetchUtil;
import org.springframework.stereotype.Component;

import java.util.Objects;

/**
 * Glen AutoTest Platform
 *
 * @Description
 * @Author Glen Team
 * @Remark Glen AutoTest Platform
 * @Version 1.0
 **/
@Component
public class SeleniumAssertionOperationServiceImpl implements SeleniumAssertionOperationService {
    @Override
    public UiOperationResultDTO equalValue(Object value, Object expectValue) {
        UiOperationResultDTO resultDTO = UiOperationResultDTO.builder().operationState(Objects.equals(value, expectValue))
                .actualValue(value).expectValue(expectValue).build();
        return resultDTO;
    }

    @Override
    public UiOperationResultDTO notEqualValue(Object value, Object expectValue) {
        UiOperationResultDTO resultDTO = UiOperationResultDTO.builder().operationState(!Objects.equals(value, expectValue))
                .actualValue(value).expectValue(expectValue).build();
        return resultDTO;
    }

    @Override
    public UiOperationResultDTO containValue(String value, String expectValue) {
        UiOperationResultDTO resultDTO = UiOperationResultDTO.builder().operationState(value.contains(expectValue))
                .actualValue(value).expectValue(expectValue).build();
        return resultDTO;
    }

    @Override
    public UiOperationResultDTO notContainValue(String value, String expectValue) {
        UiOperationResultDTO resultDTO = UiOperationResultDTO.builder().operationState(!value.contains(expectValue))
                .actualValue(value).expectValue(expectValue).build();
        return resultDTO;
    }

    @Override
    public UiOperationResultDTO greaterThan(Long value, Long expectValue) {
        UiOperationResultDTO resultDTO = UiOperationResultDTO.builder().operationState(value > expectValue)
                .actualValue(value).expectValue(expectValue).build();
        return resultDTO;
    }

    @Override
    public UiOperationResultDTO lessThan(Long value, Long expectValue) {
        UiOperationResultDTO resultDTO = UiOperationResultDTO.builder().operationState(value < expectValue)
                .actualValue(value).expectValue(expectValue).build();
        return resultDTO;
    }

    @Override
    public UiOperationResultDTO existElement(String locationType, String locationExpress) {
        UiOperationResultDTO resultDTO = UiOperationResultDTO.builder()
                .expectValue("locationType="+locationType+",locationExpress="+locationExpress).build();
        try {
            SeleniumFetchUtil.findElement(locationType,locationExpress,0L);
            resultDTO.setOperationState(true);
        }catch (Exception e){
            resultDTO.setOperationState(false);
        }
        return resultDTO;
    }

    @Override
    public UiOperationResultDTO absentElement(String locationType, String locationExpress) {
        UiOperationResultDTO uiOperationResultDTO = existElement(locationType, locationExpress);
        uiOperationResultDTO.setOperationState(!uiOperationResultDTO.getOperationState());
        return uiOperationResultDTO;
    }

    @Override
    public UiOperationResultDTO enableElement(String locationType, String locationExpress) {
        UiOperationResultDTO resultDTO = UiOperationResultDTO.builder()
                .expectValue("locationType="+locationType+",locationExpress="+locationExpress).build();
        try {
            boolean enabled = SeleniumFetchUtil.findElement(locationType, locationExpress, 0L).isEnabled();
            resultDTO.setOperationState(enabled);
        }catch (Exception e){
            resultDTO.setOperationState(false);
        }
        return resultDTO;
    }

    @Override
    public UiOperationResultDTO disableElement(String locationType, String locationExpress) {
        UiOperationResultDTO operationResultDTO = enableElement(locationType, locationExpress);
        operationResultDTO.setOperationState(!operationResultDTO.getOperationState());
        return operationResultDTO;
    }

    @Override
    public UiOperationResultDTO visibleElement(String locationType, String locationExpress) {
        UiOperationResultDTO resultDTO = UiOperationResultDTO.builder()
                .expectValue("locationType="+locationType+",locationExpress="+locationExpress).build();
        try {
            boolean displayed = SeleniumFetchUtil.findElement(locationType, locationExpress, 0L).isDisplayed();
            resultDTO.setOperationState(displayed);
        }catch (Exception e){
            resultDTO.setOperationState(false);
        }
        return resultDTO;
    }

    @Override
    public UiOperationResultDTO invisibleElement(String locationType, String locationExpress) {
        UiOperationResultDTO operationResultDTO = visibleElement(locationType, locationExpress);
        operationResultDTO.setOperationState(!operationResultDTO.getOperationState());
        return operationResultDTO;
    }

    @Override
    public UiOperationResultDTO selectElement(String locationType, String locationExpress) {
        UiOperationResultDTO resultDTO = UiOperationResultDTO.builder()
                .expectValue("locationType="+locationType+",locationExpress="+locationExpress).build();
        try {
            boolean selected = SeleniumFetchUtil.findElement(locationType, locationExpress, 0L).isSelected();
            resultDTO.setOperationState(selected);
        }catch (Exception e){
            resultDTO.setOperationState(false);
        }
        return resultDTO;
    }

    @Override
    public UiOperationResultDTO unselectElement(String locationType, String locationExpress) {
        UiOperationResultDTO operationResultDTO = selectElement(locationType, locationExpress);
        operationResultDTO.setOperationState(!operationResultDTO.getOperationState());
        return operationResultDTO;
    }
}
