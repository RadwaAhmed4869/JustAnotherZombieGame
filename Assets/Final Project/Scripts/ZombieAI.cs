using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.AI;
using UnityEngine.UI;


public class ZombieAI : MonoBehaviour
{
    private float health;
    [SerializeField] float maxHealth;
    [SerializeField] GameObject canvas_hp;
    [SerializeField] Image img_hp;

    protected Animator anim;
    [SerializeField] protected bool isDead;

    protected CapsuleCollider zombieCollider;

    //[SerializeField] private int MaxNumberOfZombies; // 22
    private int currentDeadZombies = 0;

    protected virtual void Start()
    {
        //Debug.Log("Start from parent");

        anim = GetComponent<Animator>();
        zombieCollider = GetComponent<CapsuleCollider>();

        health = maxHealth;
        img_hp.transform.localScale = new Vector3(health / maxHealth, 1, 1);
        isDead = false;
    }

    public void TakeDamage(float amount)
    {
        health -= amount;
        img_hp.transform.localScale = new Vector3(health / maxHealth, 1, 1);

        if (health <= 0f)
        {
            Die();
        }
    }


    protected virtual void Die()
    {
        zombieCollider.radius = 0.01f;
        canvas_hp.SetActive(false);
        isDead = true;
        anim.SetTrigger("isDead");

        currentDeadZombies++;
    }

    protected virtual void PlayAttackSound() { }
}