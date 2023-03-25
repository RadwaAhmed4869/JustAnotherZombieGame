using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.AI;
using UnityEngine.UI;


public class ZombieAI : MonoBehaviour
{
    private float health;
    [SerializeField] float maxHealth;
    [SerializeField] Image img_hp;

    [SerializeField] protected bool isDead;


    protected virtual void Start()
    {
        Debug.Log("Start from parent");

        health = maxHealth;
        img_hp.transform.localScale = new Vector3(health / maxHealth, 1, 1);
        isDead = false;
    }


    private void Update()
    {

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
        isDead = true;
    }
}