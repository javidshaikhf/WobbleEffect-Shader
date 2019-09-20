Shader "Custom/WobbleShader"
{
    Properties
    {

        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0


        _Amp("Amplitube", Range(0,1)) = 0.4
        _Frq("Freq", Range(1, 8)) = 2
        _AnimSpeed("Anim Speed", Range(0,5)) = 1


    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        CGPROGRAM
        
        #pragma surface surf Standard fullforwardshadows vertex:vert addshadow
        #pragma target 3.0

        sampler2D _MainTex;
        half _Glossiness;
        half _Metallic;
        fixed4 _Color;

        float _Amp;
        float _Frq;
        float _AnimSpeed;


        struct Input
        {
            float2 uv_MainTex;
        };


        void vert(inout appdata_full data){

            float4 modifiePos = data.vertex;
            modifiePos.y += sin(data.vertex.x * _Frq + _Time.y * _AnimSpeed) * _Amp;

            float3 posPlusTangent = data.vertex + data.tangent * 0.01;
            posPlusTangent.y += sin(posPlusTangent.x *  _Frq + _Time.y * _AnimSpeed) * _Amp;

            float3 bitTangent = cross(data.normal, data.tangent);
            float3 posPlusBitTangent = data.vertex + bitTangent * 0.01;
            posPlusBitTangent.y  += sin(posPlusBitTangent.x *  _Frq + _Time.y * _AnimSpeed) * _Amp;

            float3 modifiedTangent = posPlusTangent - modifiePos;
            float3 modifiedBitTangent = posPlusBitTangent - modifiePos;

            float3 modifiedNormal = cross(modifiedTangent, modifiedBitTangent);
            data.normal = normalize(modifiedNormal);
            data.vertex = modifiePos;


        }

       
        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            // Albedo comes from a texture tinted by color
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = c.rgb;
            // Metallic and smoothness come from slider variables
            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Standard"
}
