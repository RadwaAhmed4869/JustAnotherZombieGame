using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FPSController : MonoBehaviour
{

    [SerializeField, Range(0.1f, 10)] private float lookSpeedX = 0.7f;
    [SerializeField, Range(0.1f, 10)] private float lookSpeedY = 1.0f;
    [SerializeField, Range(1, 180)] private float upperLookLimit = 45.0f;
    [SerializeField, Range(1, 180)] private float lowerLookLimit = 45.0f;

    [SerializeField, Range(1, 180)] private float rightLookLimit = 20.0f;
    [SerializeField, Range(1, 180)] private float leftLookLimit = 20.0f;

    [SerializeField] private Camera playerCamera;

    private Vector3 moveDirection;
    private Vector2 currentIput;

    private float rotationX = 5;
    private float rotationY = 180;

    private void Awake()
    {
        Cursor.lockState = CursorLockMode.Locked;
        Cursor.visible = false;
    }

    private void Start()
    {
        transform.localRotation = Quaternion.Euler(0, 0, 0);
    }

    void Update()
    {
        HandleMouseLook();
    }
    private void HandleMouseLook()
    {
        rotationX += Input.GetAxis("Mouse Y") * lookSpeedY;
        rotationX = Mathf.Clamp(rotationX, -upperLookLimit, lowerLookLimit);

        transform.localRotation = Quaternion.Euler(rotationX, rotationY, 0);

        rotationY += Input.GetAxis("Mouse X") * lookSpeedX;
        rotationY = Mathf.Clamp(rotationY, -rightLookLimit, leftLookLimit);

        transform.localRotation = Quaternion.Euler(rotationX, rotationY, 0);
    }
}
