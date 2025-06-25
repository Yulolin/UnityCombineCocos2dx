using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine;
using TMPro; // 如果使用TextMeshPro


public class UnityTest : MonoBehaviour
{

    private void Start()
    {
        Debug.Log("当前渲染 API: " + SystemInfo.graphicsDeviceType);
    }
    public TMP_Text touchPosText;
    private void Update()
    {
        foreach (Touch touch in Input.touches)
        {
            touchPosText.text = touch.position.ToString();
        }
    }

    public void touchButton(string message)
    {
        Debug.Log(message);
    }

}
