// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Standard PBR with effects"
{
	Properties
	{
		[Enum(Back,2,Front,1,Off,0)]_CullMode("Cull Mode", Range( 0 , 2)) = 2
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		[Header(Standard PBR)]_Color("Color", Color) = (1,1,1,1)
		_MainTex("MainTex", 2D) = "white" {}
		[SingleLineTexture]_MetallicGlossMap("Metalic Gloss Map", 2D) = "white" {}
		[Gamma]_Metalic("Metalic", Range( 0 , 1)) = 0
		_Smoothness("Smoothness", Range( 0 , 1)) = 0.8033642
		[Normal][SingleLineTexture]_BumpMap("Normal Map", 2D) = "bump" {}
		_BumpScale("Normal Scale", Float) = 1
		[SingleLineTexture]_OcclusionMap("AO Map", 2D) = "white" {}
		_OcclusionStrength("AO Strength", Range( 0 , 1)) = 1
		[HDR]_EmissionColor("Emission Color", Color) = (0,0,0,0)
		[SingleLineTexture]_EmissionMap("Emission Map", 2D) = "white" {}
		[Header(Glowing Effect)][Toggle]_GlowingDisable("Glowing Disable", Range( 0 , 1)) = 1
		[HDR]_GlowColor("Glow Color", Color) = (0,0,0,0)
		_GlowSpeed("Glow Speed", Float) = 1
		_GlowPower("Glow Power", Float) = 5
		[Header(Disolve Effect)][Toggle]_DissolveDisable("Dissolve Disable", Range( 0 , 1)) = 1
		[HDR]_DissolveColor("Dissolve Color", Color) = (1.968627,1.968627,1.968627,0)
		_DissolveMap("Dissolve Map", 2D) = "white" {}
		_DissolveAmount("Dissolve Amount", Range( 0 , 1)) = 1
		_DissolveThickness("Dissolve Thickness", Range( 0 , 1)) = 0.6542065
		_DissolveFalloff("Dissolve Falloff", Float) = 0
		_EdgeLength ( "Edge length", Range( 2, 50 ) ) = 15.9
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull [_CullMode]
		CGINCLUDE
		#include "UnityStandardUtils.cginc"
		#include "UnityShaderVariables.cginc"
		#include "Tessellation.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 4.6
		#ifdef UNITY_PASS_SHADOWCASTER
			#undef INTERNAL_DATA
			#undef WorldReflectionVector
			#undef WorldNormalVector
			#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
			#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
			#define WorldNormalVector(data,normal) half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))
		#endif
		struct Input
		{
			float2 uv_texcoord;
			half ASEVFace : VFACE;
			float3 worldPos;
			INTERNAL_DATA
			float3 worldNormal;
		};

		uniform float _CullMode;
		uniform sampler2D _BumpMap;
		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;
		uniform float _BumpScale;
		uniform float4 _Color;
		uniform float4 _EmissionColor;
		uniform sampler2D _EmissionMap;
		uniform float4 _EmissionMap_ST;
		uniform float _GlowPower;
		uniform float4 _GlowColor;
		uniform float _GlowSpeed;
		uniform float _GlowingDisable;
		uniform sampler2D _DissolveMap;
		uniform float4 _DissolveMap_ST;
		uniform float _DissolveAmount;
		uniform float _DissolveThickness;
		uniform float _DissolveFalloff;
		uniform float4 _DissolveColor;
		uniform float _DissolveDisable;
		uniform sampler2D _MetallicGlossMap;
		uniform float _Metalic;
		uniform float _Smoothness;
		uniform sampler2D _OcclusionMap;
		uniform float _OcclusionStrength;
		uniform float _Cutoff = 0.5;
		uniform float _EdgeLength;

		float4 tessFunction( appdata_full v0, appdata_full v1, appdata_full v2 )
		{
			return UnityEdgeLengthBasedTess (v0.vertex, v1.vertex, v2.vertex, _EdgeLength);
		}

		void vertexDataFunc( inout appdata_full v )
		{
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float3 temp_output_121_18 = UnpackScaleNormal( tex2D( _BumpMap, uv_MainTex ), _BumpScale );
			float3 switchResult112 = (((i.ASEVFace>0)?(temp_output_121_18):(( temp_output_121_18 * float3( 1,1,-1 ) ))));
			float3 Normal28 = switchResult112;
			o.Normal = Normal28;
			float4 temp_output_15_0_g4 = ( _Color * tex2D( _MainTex, uv_MainTex ) );
			float3 Albedo26 = (temp_output_15_0_g4).rgb;
			o.Albedo = Albedo26;
			float2 uv_EmissionMap = i.uv_texcoord * _EmissionMap_ST.xy + _EmissionMap_ST.zw;
			float4 Emission30 = ( _EmissionColor * tex2D( _EmissionMap, uv_EmissionMap ) );
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float3 ase_worldTangent = WorldNormalVector( i, float3( 1, 0, 0 ) );
			float3 ase_worldBitangent = WorldNormalVector( i, float3( 0, 1, 0 ) );
			float3x3 ase_tangentToWorldFast = float3x3(ase_worldTangent.x,ase_worldBitangent.x,ase_worldNormal.x,ase_worldTangent.y,ase_worldBitangent.y,ase_worldNormal.y,ase_worldTangent.z,ase_worldBitangent.z,ase_worldNormal.z);
			float fresnelNdotV5_g2 = dot( mul(ase_tangentToWorldFast,Normal28), ase_worldViewDir );
			float fresnelNode5_g2 = ( 0.0 + 1.0 * pow( 1.0 - fresnelNdotV5_g2, _GlowPower ) );
			float mulTime4_g2 = _Time.y * _GlowSpeed;
			float4 lerpResult17_g2 = lerp( ( saturate( fresnelNode5_g2 ) * _GlowColor * (0.0 + (sin( mulTime4_g2 ) - -1.0) * (1.0 - 0.0) / (1.0 - -1.0)) ) , float4( 0,0,0,0 ) , _GlowingDisable);
			float4 GlowEmission51 = lerpResult17_g2;
			float2 uv_DissolveMap = i.uv_texcoord * _DissolveMap_ST.xy + _DissolveMap_ST.zw;
			float temp_output_5_0_g3 = ( tex2D( _DissolveMap, uv_DissolveMap ).r + (-1.0 + (_DissolveAmount - 0.0) * (1.0 - -1.0) / (1.0 - 0.0)) );
			float saferPower9_g3 = max( ( 1.0 - ( temp_output_5_0_g3 - _DissolveThickness ) ) , 0.0001 );
			float4 lerpResult17_g3 = lerp( ( saturate( pow( saferPower9_g3 , _DissolveFalloff ) ) * _DissolveColor ) , float4( 0,0,0,0 ) , _DissolveDisable);
			o.Emission = ( Emission30 + GlowEmission51 + lerpResult17_g3 ).rgb;
			float4 tex2DNode3_g4 = tex2D( _MetallicGlossMap, uv_MainTex );
			float Matalic32 = ( tex2DNode3_g4.r * _Metalic );
			o.Metallic = Matalic32;
			float Smoothness33 = ( tex2DNode3_g4.a * _Smoothness );
			o.Smoothness = Smoothness33;
			float lerpResult16_g4 = lerp( 1.0 , tex2D( _OcclusionMap, uv_MainTex ).g , _OcclusionStrength);
			float AO34 = lerpResult16_g4;
			o.Occlusion = AO34;
			o.Alpha = 1;
			float lerpResult16_g3 = lerp( saturate( temp_output_5_0_g3 ) , 1.0 , _DissolveDisable);
			clip( lerpResult16_g3 - _Cutoff );
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha fullforwardshadows vertex:vertexDataFunc tessellate:tessFunction 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 4.6
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float4 tSpace0 : TEXCOORD2;
				float4 tSpace1 : TEXCOORD3;
				float4 tSpace2 : TEXCOORD4;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				vertexDataFunc( v );
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
775;73;869;737;1000.679;-81.13212;1.198543;True;False
Node;AmplifyShaderEditor.CommentaryNode;38;-447.8169,-420.5703;Inherit;False;828.6943;606.5009;Standard PBR;9;111;112;39;33;32;34;26;30;28;;1,1,1,1;0;0
Node;AmplifyShaderEditor.FunctionNode;121;-419.331,-170.7061;Inherit;False;Standard BPR;2;;4;68943c8a35f042540a28ee931e972d9d;0;0;7;FLOAT3;0;FLOAT;23;FLOAT3;18;COLOR;22;FLOAT;19;FLOAT;20;FLOAT;21
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;111;-142.4593,-126.7246;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;1,1,-1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SwitchByFaceNode;112;-12.26025,-234.9246;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;64;-634.5157,426.1837;Inherit;False;731.595;173.7305;Glow;2;51;49;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;28;164.9665,-292.7817;Inherit;False;Normal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;49;-584.5157,483.9141;Inherit;False;28;Normal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FunctionNode;119;-383.8774,489.3105;Inherit;False;Glowing;14;;2;15182ad90dc7e7d499eba7113e22bf3a;0;1;12;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;30;164.9665,-135.7817;Inherit;False;Emission;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;51;-126.9208,484.7236;Inherit;False;GlowEmission;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;26;165.3634,-371.2824;Inherit;False;Albedo;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FunctionNode;120;980.4128,-110.0407;Inherit;False;DissolveEffect;20;;3;6055670871abaee4cbbc605add16e196;0;0;2;COLOR;14;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;54;994.4371,-192.323;Inherit;False;51;GlowEmission;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;33;161.9665,17.21819;Inherit;False;Smoothness;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;34;163.9665,94.2183;Inherit;False;AO;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;32;163.9665,-58.78175;Inherit;False;Matalic;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;31;997.4211,-271.161;Inherit;False;30;Emission;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;35;1323.025,-138.4652;Inherit;False;32;Matalic;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;109;1454.842,326.9741;Inherit;False;Property;_CullMode;Cull Mode;0;1;[Enum];Create;True;0;3;Back;2;Front;1;Off;0;0;True;0;False;2;0;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;29;1326.124,-251.6656;Inherit;False;28;Normal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;37;1326.025,15.53479;Inherit;False;34;AO;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;39;164.0235,-211.7706;Inherit;False;Alpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;27;1326.322,-335.0664;Inherit;False;26;Albedo;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;36;1307.025,-63.46524;Inherit;False;33;Smoothness;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;55;1207.837,-210.4229;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1561.758,-256.4472;Float;False;True;-1;6;ASEMaterialInspector;0;0;Standard;Standard PBR with effects;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;TransparentCutout;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;2;15.9;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;1;-1;-1;27;0;False;0;0;True;109;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;111;0;121;18
WireConnection;112;0;121;18
WireConnection;112;1;111;0
WireConnection;28;0;112;0
WireConnection;119;12;49;0
WireConnection;30;0;121;22
WireConnection;51;0;119;0
WireConnection;26;0;121;0
WireConnection;33;0;121;20
WireConnection;34;0;121;21
WireConnection;32;0;121;19
WireConnection;39;0;121;23
WireConnection;55;0;31;0
WireConnection;55;1;54;0
WireConnection;55;2;120;14
WireConnection;0;0;27;0
WireConnection;0;1;29;0
WireConnection;0;2;55;0
WireConnection;0;3;35;0
WireConnection;0;4;36;0
WireConnection;0;5;37;0
WireConnection;0;10;120;0
ASEEND*/
//CHKSM=4EB0E84D9222533CC7274AA72E535858341F1D5E