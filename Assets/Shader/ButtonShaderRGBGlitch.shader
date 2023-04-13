// https://answers.unity.com/questions/583960/apply-shader-to-a-sprite.html

Shader "Custom/ButtonShaderRGBGlitch"
{
     Properties
     {
        _MainTex ("Base (RGB)", 2D) = "white" {}
        _DistortionTex ("Distortion (RGB)", 2D) = "white" {}
        _offset ("rgb offset", Range (0, 1)) = 0
        _speed ("offset speed", Range (0, 100)) = 0
     }
     SubShader
     {
         Tags 
         { 
             "RenderType" = "Opaque" 
             "Queue" = "Transparent+1" 
         }
 
         Pass
         {
             ZWrite Off
             Blend SrcAlpha OneMinusSrcAlpha 
  
             CGPROGRAM
             #pragma vertex vert
             #pragma fragment frag
             #pragma multi_compile DUMMY PIXELSNAP_ON
  
            uniform sampler2D _MainTex;
            uniform sampler2D _DistortionTex;
            uniform float _offset;
            uniform float _speed; 
             
             float4 _Color;
             float _Pixelate;
 
             struct Vertex
             {
                 float4 vertex : POSITION;
                 float2 uv_MainTex : TEXCOORD0;
                 float2 uv2 : TEXCOORD1;
             };
     
             struct Fragment
             {
                 float4 vertex : POSITION;
                 float2 uv_MainTex : TEXCOORD0;
                 float2 uv2 : TEXCOORD1;
             };
  
             Fragment vert(Vertex v)
             {
                 Fragment o;
     
                 o.vertex = UnityObjectToClipPos(v.vertex);
                 o.uv_MainTex = v.uv_MainTex;
                 o.uv2 = v.uv2;
     
                 return o;
             }
                                                     
             float4 frag(Fragment IN) : COLOR
             {
                //red channel
                float moveY = ((_Time * _speed) % 1);
                float4 distortion = tex2D(_DistortionTex, IN.uv_MainTex * float2(0.2, 0.2) + float2(1, moveY));

                float2 rUV = IN.uv_MainTex + _offset * distortion;

                float4 red = tex2D(_MainTex, rUV);

                //green and blue channel
                float4 greenBlue = tex2D(_MainTex, IN.uv_MainTex);

                float4 color = float4(red.r, greenBlue.g, greenBlue.b, max(greenBlue.a, red.a));
                     
                 return color;
             }
 
             ENDCG
         }
     }
}