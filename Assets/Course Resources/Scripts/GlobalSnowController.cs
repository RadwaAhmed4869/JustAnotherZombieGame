using System.Collections;
using System.Collections.Generic;
using UnityEngine;
[ExecuteInEditMode]
public class GlobalSnowController : MonoBehaviour
{
    [Range(0f, 1f)]
    public float snowLevel;
    public float snowTiling = 1;
    public Color SnowColor = Color.white;
    public Texture2D SnowColorMap = Texture2D.whiteTexture,
                     SnowNormalMap = Texture2D.normalTexture,
                     SnowMaskMap = Texture2D.whiteTexture;
    public float NormalScale = 1;
    [Range(0f, 1f)]
    public float Metallic, Smoothness;
    //public float AOStrength;
    
    private void Update()
    {
        //Updates the _PlayerPos variable in all the shaders
        //Be aware that the parameter name has to match the one in your shaders or it wont' work
        Shader.SetGlobalVector("PlayerPos", transform.position); //"transform" is the transform of the Player 
        Shader.SetGlobalVector("PlayerSize", transform.localScale);
        Shader.SetGlobalFloat("SnowLevel", snowLevel);
        Shader.SetGlobalColor("SnowColor", SnowColor);
        Shader.SetGlobalTexture("SnowColorTexture", SnowColorMap);
        Shader.SetGlobalTexture("SnowNormalMap", SnowNormalMap);
        Shader.SetGlobalFloat("SnowNormalScale", NormalScale);
        Shader.SetGlobalTexture("SnowMaskMap", SnowMaskMap);
        Shader.SetGlobalFloat("SnowMetallic", Metallic);
        Shader.SetGlobalFloat("SnowSmoothness", Smoothness);
        //Shader.SetGlobalFloat("SnowAOStrength", AOStrength);
        Shader.SetGlobalFloat("SnowTiling", snowTiling);

    }
}
