Shader "Unlit/WaterShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _NoiseTex("Displace", 2D) = "white" {}
        _Color1("Foam Color", Color) = (1,0,0,1)
        _Color2("Water Color", Color) = (1,0,0,1)
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
                float4 normal : NORMAL;
                float4 texcoord : TEXCOORD0;
            };

            struct VertexOutput
            {
                float4 texcoord : TEXCOORD0;
                float4 position : SV_POSITION;
            };

            sampler2D _MainTex;
            sampler2D _NoiseTex;
            float4 _MainTex_ST;
            float4 _NoiseTex_ST;
            half4 _Color1;
            half4 _Color2;

            VertexOutput vert (VertexInput inputData)
            {
                VertexOutput output;
                // output.position = UnityObjectToClipPos(inputData.vertex); //output projected position of the vertex on the screen

                float displacement = tex2Dlod(_NoiseTex, inputData.texcoord * _NoiseTex_ST);
                output.position =  UnityObjectToClipPos(inputData.vertex + (inputData.normal * displacement * 0.1f));

                output.texcoord.xy = (inputData.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw);                
                return output;
            }

            half4 frag (VertexOutput i) : COLOR
            {
                float4 whitePercentage = tex2D(_NoiseTex, i.texcoord);
                float4 color = (whitePercentage * _Color1) + (( 1 - whitePercentage) * _Color2);
                return color;
            }
            ENDCG
        }
    }
}
