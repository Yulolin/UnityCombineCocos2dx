LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

$(call import-add-path,$(LOCAL_PATH)/../../../../../cocos2d)
$(call import-add-path,$(LOCAL_PATH)/../../../../../cocos2d/external)
$(call import-add-path,$(LOCAL_PATH)/../../../../../cocos2d/cocos)
$(call import-add-path,$(LOCAL_PATH)/../../../../../cocos2d/cocos/audio/include)
$(call import-add-path,$(LOCAL_PATH)/../../../../../redwise_sdk)
$(call import-add-path,$(LOCAL_PATH)/../../../../../bubble_sdk)
# $(call import-add-path,$(LOCAL_PATH)/../../../../../red_utils)
$(call import-add-path,$(LOCAL_PATH)/../../../../../red_protocol)

LOCAL_MODULE := Cocos2dxPlugin
LOCAL_LDLIBS := -llog
LOCAL_ARM_MODE := arm

#___AUTO_SRC_START___
LOCAL_SRC_FILES := ./main.cpp \
    ../../../source/RenderAPI.cpp \
	../../../source/Cocos2dxPlugin.cpp \
	../../../source/RenderAPI_OpenGLES2.cpp \
    ../../../../Classes/AppDelegate.cpp \
    ../../../../Classes/BubbleAction/bsBubbleActionDrop.cpp \
    ../../../../Classes/BubbleAction/bsBubbleActionRegister.cpp \
    ../../../../Classes/Extesions/bsActionKeepDirection.cpp \
    ../../../../Classes/Extesions/bsAimLine.cpp \
    ../../../../Classes/Extesions/bsCustomCardinalSplineTo.cpp \
    ../../../../Classes/Extesions/bsCustomExpoAction.cpp \
    ../../../../Classes/Extesions/bsCustomParticle_RandomTexture.cpp \
    ../../../../Classes/Extesions/bsCustomScrollView.cpp \
    ../../../../Classes/Extesions/bsDrawBezierLine.cpp \
    ../../../../Classes/Extesions/bsGlobalObjectPool.cpp \
    ../../../../Classes/Extesions/bsMTipsUI.cpp \
    ../../../../Classes/Extesions/bsMoveAlongCircularArc.cpp \
    ../../../../Classes/Extesions/bsUIPopCommand.cpp \
    ../../../../Classes/GameChecker/BsGameCheck_ClearAllColor.cpp \
    ../../../../Classes/GameChecker/BsGameCheck_Collect.cpp \
    ../../../../Classes/GameChecker/BsGameCheck_Diamond.cpp \
    ../../../../Classes/GameChecker/BsGameChecker.cpp \
    ../../../../Classes/GamePower/bsGamePowerController.cpp \
    ../../../../Classes/GamePower/bsGamePowerLuckController.cpp \
    ../../../../Classes/GamePower/bsGamePowerSelectHighlight.cpp \
    ../../../../Classes/GameUI/BsGameLayer.cpp \
    ../../../../Classes/GameUI/BubConsole.cpp \
    ../../../../Classes/GameUI/ClearState_StageAfterRound.cpp \
    ../../../../Classes/GameUI/ClearState_StageLevelEnd.cpp \
    ../../../../Classes/GameUI/ClearState_StageRound.cpp \
    ../../../../Classes/GameUI/ClearState_StageShoot.cpp \
    ../../../../Classes/GameUI/DebugNode.cpp \
    ../../../../Classes/GameUI/HeartLoseUI.cpp \
    ../../../../Classes/GameUI/LevelTopDiamodMgr.cpp \
    ../../../../Classes/GameUI/bsBustlingUI.cpp \
    ../../../../Classes/GameUI/bsGameBackdropLayer.cpp \
    ../../../../Classes/GameUI/bsGameCameraController.cpp \
    ../../../../Classes/GameUI/bsGameWinUI.cpp \
    ../../../../Classes/GameUI/bsMComboLayer.cpp \
    ../../../../Classes/GameUI/bsMGameTopBar.cpp \
    ../../../../Classes/GameUI/bsMoreStepUI.cpp \
    ../../../../Classes/GameUI/bsToastUI.cpp \
    ../../../../Classes/Guide/bsGuideAimlineOpt.cpp \
    ../../../../Classes/Guide/bsGuideBounceOpt.cpp \
    ../../../../Classes/Guide/bsGuideBubbleNew.cpp \
    ../../../../Classes/Guide/bsMGuideBubble.cpp \
    ../../../../Classes/Guide/bsMGuideController.cpp \
    ../../../../Classes/Guide/bsMGuideStyleA.cpp \
    ../../../../Classes/Guide/bsMGuideStyleB.cpp \
    ../../../../Classes/Guide/bsMGuideSwitchOpt.cpp \
    ../../../../Classes/HomeUI/Map/bsCustomTableView.cpp \
    ../../../../Classes/HomeUI/Map/bsCustomTableViewCell.cpp \
    ../../../../Classes/HomeUI/Map/bsMapItemCell.cpp \
    ../../../../Classes/HomeUI/Map/bsMapItemLayer.cpp \
    ../../../../Classes/HomeUI/bsHomePages.cpp \
    ../../../../Classes/HomeUI/bsLevelFailedUI.cpp \
    ../../../../Classes/HomeUI/bsLifeValueNode.cpp \
    ../../../../Classes/HomeUI/bsMHomeLayer.cpp \
    ../../../../Classes/HomeUI/bsMLevelLayerVideo.cpp \
    ../../../../Classes/HomeUI/bsMLevelUI.cpp \
    ../../../../Classes/HomeUI/bsMLevelVideo.cpp \
    ../../../../Classes/HomeUI/bsNavgationBar.cpp \
    ../../../../Classes/HomeUI/bsPushNotificationTips.cpp \
    ../../../../Classes/HomeUI/bsUnlimitedLivesTips.cpp \
    ../../../../Classes/Loading/bsLoadingLayer.cpp \
    ../../../../Classes/Platform/bsBCPlatform.cpp \
    ../../../../Classes/PromptBox/bsAdChoices.cpp \
    ../../../../Classes/PromptBox/bsBubbleGamePlay.cpp \
    ../../../../Classes/PromptBox/bsEvaluateModule.cpp \
    ../../../../Classes/PromptBox/bsEvaluateUI.cpp \
    ../../../../Classes/PromptBox/bsNoNetworkUI.cpp \
    ../../../../Classes/PromptBox/bsReadygoLayer.cpp \
    ../../../../Classes/RedInterstitialAd/bsBulldogGameOverIconAdCell.cpp \
    ../../../../Classes/RedInterstitialAd/bsBulldogGameOverIconAdLayer.cpp \
    ../../../../Classes/RedInterstitialAd/bsBulldogMapIconAdLayer.cpp \
    ../../../../Classes/Scene/BsGameScene.cpp \
    ../../../../Classes/Scene/BsSceneTransitionEffect.cpp \
    ../../../../Classes/ScreenRecord/bsScreenRecord.cpp \
    ../../../../Classes/ScreenRecord/bsScreenRecordImpl.cpp \
    ../../../../Classes/ScreenRecord/bsScreenRecordPlayer.cpp \
    ../../../../Classes/ScreenRecord/proto_record.pb.cc \
    ../../../../Classes/Setting/bsMSettingViewUI.cpp \
    ../../../../Classes/Setting/bsSettingButtonInLevel.cpp \
    ../../../../Classes/Setting/bsSettingModule.cpp \
    ../../../../Classes/Shooter/BsShooterCalculator.cpp \
    ../../../../Classes/Shooter/bsMShooterUI.cpp \
    ../../../../Classes/Shooter/bsShootBubble_Bomb.cpp \
    ../../../../Classes/Shooter/bsShootBubble_Flash.cpp \
    ../../../../Classes/Shooter/bsShootBubble_Normal.cpp \
    ../../../../Classes/Shooter/bsShootBubble_Rainbow.cpp \
    ../../../../Classes/Shooter/bsShootBubble_Rocket.cpp \
    ../../../../Classes/Shooter/bsShootColorGenerator.cpp \
    ../../../../Classes/Shooter/bsShootLabelEffect.cpp \
    ../../../../Classes/Shooter/bsShooterLayer.cpp \
    ../../../../Classes/Shooter/bsShooterProcessor.cpp \
    ../../../../Classes/Tools/PageFlippingEffect.cpp \
    ../../../../Classes/Tools/bsActionGravityThrow.cpp \
    ../../../../Classes/Tools/bsBlankButton.cpp \
    ../../../../Classes/Tools/bsFunction.cpp \
    ../../../../Classes/Tools/bsRotateAround.cpp \
    ../../../../Classes/Tools/bsTimeModule.cpp \
    ../../../../Classes/Tools/bsWebUtils.cpp \
    ../../../../Classes/Tools/ccb/bsQCoreBtn.cpp \
    ../../../../Classes/Tools/ccb/bsQCoreBtnScale.cpp \
    ../../../../Classes/Tools/ccb/bsQCoreHelper.cpp \
    ../../../../Classes/Tools/spine/bsRotateSpineBone.cpp \
    ../../../../Classes/core/AbTestMgr.cpp \
    ../../../../Classes/core/BsAssets.cpp \
    ../../../../Classes/core/BsGameMgr.cpp \
    ../../../../Classes/core/bsGetText.cpp \
    ../../../../Classes/core/bsLevelBubWeightModule.cpp \
    ../../../../Classes/core/bsLevelPlayData.cpp \
    ../../../../Classes/core/bsMLevelData.cpp \
    ../../../../Classes/core/bsMMapData.cpp \
    ../../../../Classes/core/bsMPlayerData.cpp \
    ../../../../Classes/core/bsMPlayerLevel.cpp \
    ../../../../Classes/core/bsNamesMgr.cpp \
    ../../../../Classes/core/bsSound.cpp \
    ../../../../Classes/core/bsUnlimitedLevel.cpp \
    ../../../../Classes/core/proto_common.pb.cc \
    ../../../../Classes/core/proto_levels.pb.cc \
#___AUTO_SRC_END___




    
#___AUTO_C_INCLUDES_START___
LOCAL_C_INCLUDES := $(LOCAL_PATH)/../../../source \
    $(LOCAL_PATH)/../../../../Classes \
    $(LOCAL_PATH)/../../../../Classes/Ads \
    $(LOCAL_PATH)/../../../../Classes/BubbleAction \
    $(LOCAL_PATH)/../../../../Classes/Extesions \
    $(LOCAL_PATH)/../../../../Classes/GameChecker \
    $(LOCAL_PATH)/../../../../Classes/GamePower \
    $(LOCAL_PATH)/../../../../Classes/GameUI \
    $(LOCAL_PATH)/../../../../Classes/Guide \
    $(LOCAL_PATH)/../../../../Classes/HomeUI \
    $(LOCAL_PATH)/../../../../Classes/HomeUI/Map \
    $(LOCAL_PATH)/../../../../Classes/Loading \
    $(LOCAL_PATH)/../../../../Classes/Platform \
    $(LOCAL_PATH)/../../../../Classes/PromptBox \
    $(LOCAL_PATH)/../../../../Classes/RedInterstitialAd \
    $(LOCAL_PATH)/../../../../Classes/Scene \
    $(LOCAL_PATH)/../../../../Classes/ScreenRecord \
    $(LOCAL_PATH)/../../../../Classes/Setting \
    $(LOCAL_PATH)/../../../../Classes/Shooter \
    $(LOCAL_PATH)/../../../../Classes/ShopModule \
    $(LOCAL_PATH)/../../../../Classes/SkillsModule \
    $(LOCAL_PATH)/../../../../Classes/Statistics \
    $(LOCAL_PATH)/../../../../Classes/SuperProps \
    $(LOCAL_PATH)/../../../../Classes/Tools \
    $(LOCAL_PATH)/../../../../Classes/Tools/ccb \
    $(LOCAL_PATH)/../../../../Classes/Tools/spine \
    $(LOCAL_PATH)/../../../../Classes/TripleKill \
    $(LOCAL_PATH)/../../../../Classes/core \
#___AUTO_C_INCLUDES_END___



LOCAL_STATIC_LIBRARIES := cocos2dx_static
LOCAL_STATIC_LIBRARIES += redream_static
LOCAL_STATIC_LIBRARIES += bubble_sdk_static
LOCAL_STATIC_LIBRARIES += red_protocol_static
LOCAL_STATIC_LIBRARIES += redwise_static

# $(call import-add-path,$(LOCAL_PATH)/../../../../../redwise_sdk)

include $(BUILD_SHARED_LIBRARY)

# $(call import-module,.)
# $(call import-module,../redream)
# $(call import-module,../redwise_sdk)
# $(call import-module,../bubble_sdk)
# $(call import-module,../red_protocol)
#
#

$(call import-module,.)
$(call import-module,../redream)
$(call import-module,../redwise_sdk)
$(call import-module,../bubble_sdk)
$(call import-module,../red_protocol)
# $(call import-module,../red_utils)






















