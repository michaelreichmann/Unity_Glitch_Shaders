// https://answers.unity.com/questions/583960/apply-shader-to-a-sprite.html

Shader "Custom/ButtonShaderPixelate"
{
     Properties
     {
        _MainTex ("Sprite Texture", 2D) = "white" {}
        _Pixelate ("number of pixels per axis", Range (0, 100)) = 0
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
  
             sampler2D _MainTex;
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
                 float2 pixUV = floor(IN.uv_MainTex * _Pixelate) / _Pixelate;

                 float4 color = tex2D(_MainTex, pixUV);
                     
                 return color;
             }
 
             ENDCG
         }
     }
}