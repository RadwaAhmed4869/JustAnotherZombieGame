using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CrowController : ZombieAI
{
    public Transform[] waypoints;
    private int wayPointsCounter;

    //private int previousWP;
    //private int currentWP;

    [SerializeField] private float speed;
    private Rigidbody crowRB;

    protected override void Start()
    {
        base.Start();
        //Debug.Log("Start from child crow");

        crowRB = GetComponent<Rigidbody>();
    }

    void Update()
    {
        if (!isDead)
            Patrol();
    }

    public void Seek(Vector3 target)
    {
        var direction = (target - this.transform.position).normalized;
        crowRB.velocity = direction * speed;
        this.transform.LookAt(target);
    }

    private void Patrol()
    {
        Seek(waypoints[wayPointsCounter].transform.position);

        if (Vector3.SqrMagnitude(waypoints[wayPointsCounter].transform.position - this.transform.position) < 0.01f)
        {
            //Debug.Log($"bring next waypoint: {speed}");

            //previousWP = wayPointsCounter;
            
            wayPointsCounter++;
            wayPointsCounter %= waypoints.Length;

            //currentWP = wayPointsCounter;

            if(wayPointsCounter == 16)
            {
                speed = 2f;
            }
            if(wayPointsCounter == 1)
            {
                speed = 0.7f;
            }
        }
    }

    protected override void Die()
    {
        base.Die();
        crowRB.useGravity = true;
        Destroy(gameObject, 3);
    }

    //private void OnDrawGizmos()
    //{
    //    Gizmos.color = Color.white;
    //    Gizmos.DrawLine(waypoints[previousWP].position, waypoints[currentWP].position);
    //}
}
