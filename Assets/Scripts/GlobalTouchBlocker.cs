using System.Collections;
using System.Collections.Generic;
using UnityEngine.EventSystems;
using UnityEngine;

public class GlobalTouchBlocker : MonoBehaviour,IPointerClickHandler
{

    public void OnPointerClick(PointerEventData eventData)
    {
        // 矩形区域定义（屏幕空间坐标）
        Rect blockArea = new Rect(0, 0, Screen.width, Screen.height);
        // 检查触摸点是否在屏蔽区域内
        if (blockArea.Contains(eventData.position))
        {
            // 消耗事件，阻止其继续传播
            eventData.Use();
            Debug.Log($"Touch blocked at {eventData.position}");
        }
    }
}
