Shader "Unlit/ReStartShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Color("Base Color", Color) = (1,0,0,1)
    }
    SubShader
    {
        Tags{
            "Queue" = "Transparent"
            "RenderType" = "Transparent"
            "IgnoreProjector" = "True"
            }

        Pass
        {
            Blend SrcAlpha OneMinusSrcAlpha
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

            VertexOutput vert (VertexInput inputData)
            {
                VertexOutput output;
                output.position = UnityObjectToClipPos(inputData.vertex); //output projected position of the vertex on the screen

                output.texcoord.xy = (inputData.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw);
                return output;
            }

            half4 frag (VertexOutput i) : COLOR
            {
                return tex2D(_MainTex, i.texcoord) * _Color;
            }
            ENDCG
        }
    }
}
