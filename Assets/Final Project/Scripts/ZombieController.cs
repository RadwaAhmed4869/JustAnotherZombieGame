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

    private Material dissolveMatInstance;

    private float randomValue;
    private Rigidbody zombieRB;


    protected override void Start()
    {
        base.Start();
        //Debug.Log("Start from child zombie");

        zombieRB = GetComponent<Rigidbody>();
        m_Agent = GetComponent<NavMeshAgent>();

        //m_Agent.SetDestination(target.transform.position);
        m_Agent.transform.LookAt(target);

        //create a material instance

        Renderer renderer = GetComponent<Renderer>();
        if(renderer != null)
        {
            Material originalMat = renderer.material;

            dissolveMatInstance = Instantiate(originalMat);
            GetComponent<Renderer>().material = dissolveMatInstance;

            // get material of children
            Renderer[] children = GetComponentsInChildren<Renderer>();

            //for(int i = 0; i < children.Length; i++)
            //{
            //    Renderer child = children[i];
            //    Material[] materials = child.materials;
            //}

            foreach (Renderer child in children)
            {
                Material[] materials = child.materials;
                for (int j = 0; j < materials.Length; j++)
                {
                    child.material = dissolveMatInstance;
                }
            }
        }
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

    void ApplyDissolve()
    {
        float duration = 70.0f;
        float timer = 0.0f;
        float startValue = 1.0f;
        float endValue = 0.7f;

        //float value = startValue;
        float dissolveAmount = dissolveMatInstance.GetFloat("_DissolveAmount");
        while (dissolveAmount > endValue)
        {
            timer += Time.deltaTime;
            float t = Mathf.Clamp01(timer / duration);
            dissolveAmount = Mathf.Lerp(startValue, endValue, t);
            dissolveMatInstance.SetFloat("_DissolveAmount", dissolveAmount);
        }
    }

    protected override void Die()
    {
        m_Agent.isStopped = true;
        if (zombieRB != null)
        {
            Destroy(zombieRB);
        }
        base.Die();

        randomValue = Random.value;

        if (randomValue < 0.4f)
        {
            ApplyDissolve();
        }

        Destroy(gameObject, 7);
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.tag.Equals("Player"))
        {
            PlayerLife player = other.GetComponent<PlayerLife>();
            player.TakeDamage(20);
            AudioManager.instance.playSFX("ZombieAttack", 1f);
        }
    }

    //private void OnTriggerStay(Collider other)
    //{
    //    AudioManager.instance.playSFX("ZombieAttack", 1f);
    //}

    protected override void PlayAttackSound()
    {
        //base.PlayAttackSound();
        AudioManager.instance.playSFX("ZombieScream2", 0.4f);
    }
}
