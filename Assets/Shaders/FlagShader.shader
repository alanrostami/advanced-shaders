Shader "Unlit/FlagShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Color("Base Color", Color) = (1,0,0,1)
        _Speed("Speed", Float) = 2.0
        _Frequency("Frequency", Float) = 2.0
        _Amplitude("Amplitude", Float) = 2.0
    }
    
    SubShader
    {
        Tags
        {
            "Queue" = "Transparent"
            "RenderType" = "Opaque"
            // "IgnoreProjector" = "True"
        }

        Pass
        {
            // Blend SrcAlpha OneMinusSrcAlpha
            // CULL Off
            CGPROGRAM
           
            #include "UnityCG.cginc"
            #pragma vertex vert
            #pragma fragment frag

            struct VertexInput
            {
                float4 vertex : POSITION;
                float4 texcoord : TEXCOORD0;
            };

            struct VertexOutput
            {
                float4 texcoord : TEXCOORD0;
                float4 position : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            half4 _Color;
            float _Speed;
            float _Frequency;
            float _Amplitude;

            float4 vertexAnimFlag(float4 pos, float2 uv)
            {
                // pos.z = pos.z + sin(uv.x);
                pos.z = pos.z + sin((uv.x - _Time.y * _Speed) * _Frequency) * _Amplitude;
                return pos;
            }

            VertexOutput vert (VertexInput inputData)
            {
                VertexOutput output;
                output.position = UnityObjectToClipPos(inputData.vertex); //output projected position of the vertex on the screen

                // output.texcoord.xy = (inputData.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw);
                output.texcoord.xy = (inputData.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw);
                return output;
            }

            half4 frag (VertexOutput i) : COLOR
            {
                float4 color = tex2D(_MainTex, i.texcoord) * _Color;
                return color;
            }
            ENDCG
        }
    }
}
