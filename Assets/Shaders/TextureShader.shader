Shader "Unlit/TextureShader"
{
    Properties
    {
        _MainTex("Main Texture", 2D) = "white"{}
        _Color ("Main Color", Color) = (1,1,1,1)
    }
    SubShader
    {
        Tags
        {
            "Queue" = "Transparent"
            "RenderType" = "Transparent"
            "IgnoreProjector" = "True"
        }
         
        LOD 100

        Pass
        {
            Blend SrcAlpha OneMinusSrcAlpha

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            uniform sampler2D _MainTex;
            uniform half4 _Color;

            struct VertexInput
            {
                float4 texcoord: TEXCOORD0;
                float4 vertex: POSITION;
            };

            struct VertexOutput
            {
                float4 pos: SV_POSITION;
            };
 
            VertexOutput vert(VertexInput v)
            {
                VertexOutput o;
                o.pos = UnityObjectToClipPos(v.vertex);
                // o.texcoord.xy = (v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw);
                return o;
            }
 
            float drawLine(float2 uv, float start, float end)
            {
                if(uv.x > start && uv.x < end)
                {
                    return 1;
                }
                
                return 0;
            }

        
            half4 frag(VertexOutput i): COLOR
            {            
                // float4 color = tex2D(_MainTex, i.texcoord) * _Color;            
                // color.a = drawLine(i.texcoord, 0.4, 0.6);            
                // return color;        
            }


            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            // sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }
    }
}
