Shader "Unlit/hat_diffuse_ps"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
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
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float3 normal : TEXCOORD1;
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			
			v2f vert (appdata v)
			{
				v2f o;
				// screen pos
				o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);
				// uv
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);

				o.normal = v.normal;

				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				// sample the texture
				float4 col = tex2D(_MainTex, i.uv);

				// world normal
				float3 worldNormal = mul(_Object2World, i.normal);
				// world light dir
				float3 lightDir = _WorldSpaceLightPos0.xyz;

				// diffuse
				float4 diffuse = float4(1, 1, 1, 1) * max(dot(worldNormal, lightDir), 0);

				col = col * diffuse;

				return col;
			}
			ENDCG
		}
	}
}
