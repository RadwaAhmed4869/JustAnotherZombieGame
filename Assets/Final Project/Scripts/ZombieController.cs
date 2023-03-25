using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.AI;
using UnityEngine.UI;

public class ZombieController : ZombieAI
{
    [SerializeField] private Transform target;

    private NavMeshAgent m_Agent;
    [SerializeField] private float distance;
    private float currentDistance;
    private Animator anim;
    protected override void Start()
    {
        base.Start();
        Debug.Log("Start from child zombie");

        m_Agent = GetComponent<NavMeshAgent>();
        anim = GetComponent<Animator>();

        //m_Agent.SetDestination(target.transform.position);
        m_Agent.transform.LookAt(target);
    }

    public void MoveToTarget()
    {
        m_Agent.SetDestination(target.transform.position);
        m_Agent.transform.LookAt(target);
    }

    void Update()
    {
        currentDistance = Vector3.SqrMagnitude(target.transform.position - this.transform.position);
        anim.SetFloat("currentDistance", currentDistance);
        if (!isDead && currentDistance > distance)
        {
            MoveToTarget();
        }
    }

    protected override void Die()
    {
        m_Agent.isStopped = true;
        anim.SetTrigger("isDead");
        Destroy(gameObject, 3);
    }
}
