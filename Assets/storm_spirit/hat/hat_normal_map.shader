Shader "Unlit/hat_normal_map"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_Bump ("Bump", 2D) = "bump" {}
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
				float4 tangent : TANGENT;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float3 lightDirTangent : TEXCOORD1;
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex;
			sampler2D _Bump;

			float4 _MainTex_ST;
			
			v2f vert (appdata v)
			{
				v2f o;
				// screen pos
				o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);
				// uv
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);

				TANGENT_SPACE_ROTATION;

				// world light dir
				float3 lightDirWorld = _WorldSpaceLightPos0.xyz;
				float3 lightDirObj = mul(_World2Object, lightDirWorld);

				o.lightDirTangent = mul(rotation, lightDirObj);

				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				// sample the texture
				float4 col = tex2D(_MainTex, i.uv);
				float3 normalTargent = UnpackNormal(tex2D(_Bump, i.uv));


				// diffuse
				float4 diffuse = float4(1, 1, 1, 1) * max(dot(normalTargent, i.lightDirTangent), 0);

				col = col * diffuse;

				return col;
			}
			ENDCG
		}
	}
}
