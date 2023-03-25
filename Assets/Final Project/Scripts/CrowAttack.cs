using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using BBUnity.Actions;
using Pada1.BBCore;
using Pada1.BBCore.Tasks;

[Action("OurPath/CrowAttack")]

public class CrowAttack : GOAction
{
    [InParam("npc")]
    public Transform crow;

    private Vector3 currentPos;
    private Vector3 playerPos = new Vector3(0.64f, 0.18f, -3.2f);
    Vector3 direction;
    public override void OnStart()
    {
        Debug.Log("Start attack");
        currentPos = crow.position;
        base.OnStart();
    }
    public override void OnEnd()
    {
        Debug.Log(currentPos);
        Debug.Log("End attack");
        base.OnEnd();
    }

    public override TaskStatus OnUpdate()
    {
        direction = playerPos - currentPos;

        Debug.Log($"dir sqrMagn: {direction.sqrMagnitude}");

        direction.Normalize();

        crow.transform.Translate(direction * 5f * Time.deltaTime);

        //if (direction.sqrMagnitude <= 0.1f)
        //{
        //    return base.OnUpdate();
        //}
        return TaskStatus.RUNNING;

    }

    private void OnDrawGizmosSelected()
    {
        Gizmos.color = Color.white;
        Gizmos.DrawRay(crow.position, direction);
    }
}
