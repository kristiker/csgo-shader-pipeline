
// CreateTexture2DWithoutSampler(g_tFogCubeTexture) < Attribute("CubemapFogTexture"); SrgbRead(true); >;
SamplerState g_tFogCubeTexture_s : register(s45, space0);
TextureCube<float4> g_tFogCubeTexture : register(t102, space0);

void ApplyFog(inout vec3 pixelColor, vec3 vPositionWs)
{
    float2 cameraCenteredPixelPos.xy;
    float3 cameraCenteredPixelPos = CalculateCameraToPositionRayWs(vPositionWs);

    // ApplyGradientFog
    {
        float horizontalDistanceQuadratic = dot(cameraCenteredPixelPos.xy, cameraCenteredPixelPos.xy);
        bool bPixelHasGradientFog = (horizontalDistanceQuadratic > g_vGradientFogCullingParams.x) && ((vPositionWs.z * g_vGradientFogCullingParams.z) < g_vGradientFogCullingParams.y);

        [branch]
        if (bPixelHasGradientFog)
        {
            float2 _21390 = clamp(mad(g_vGradientFogBiasAndScale.zw, float2(length(cameraCenteredPixelPos.xy), _18390), g_vGradientFogBiasAndScale.xy), 0.0f.xx, 1.0f.xx);
            float _11897 = (pow(_21390.x, m_vGradientFogExponents.x) * pow(_21390.y, m_vGradientFogExponents.y)) * g_vGradientFogColor_Opacity.w;
            pixelColor = lerp(pixelColor, float4(g_vGradientFogColor_Opacity.xyz, _11897).xyz, _11897.xxx);
        }
    }

    // ApplyCubemapFog
    {
        float distanceQuadratic = dot(cameraCenteredPixelPos, cameraCenteredPixelPos);
        bool bPixelHasCubemapFog = (distanceQuadratic > g_vCubeFogCullingParams_MaxOpacity.x) && ((g_vCubeFogCullingParams_MaxOpacity.z * _18390) < g_vCubeFogCullingParams_MaxOpacity.y)
        
        if (bPixelHasCubemapFog)
        {
            float _16990 = clamp(pow(max(0.0f, mad(length(cameraCenteredPixelPos.xy), g_vCubeFog_Offset_Scale_Bias_Exponent.y, g_vCubeFog_Offset_Scale_Bias_Exponent.x)), g_vCubeFog_Offset_Scale_Bias_Exponent.w), 0.0f, 1.0f) * clamp(pow(max(0.0f, mad(_18390, g_vCubeFog_Height_Offset_Scale_Exponent_Log2Mip.y, g_vCubeFog_Height_Offset_Scale_Exponent_Log2Mip.x)), g_vCubeFog_Height_Offset_Scale_Exponent_Log2Mip.z), 0.0f, 1.0f);
            float _8437 = clamp(_16990, 0.0f, 1.0f) * g_vCubeFogCullingParams_MaxOpacity.w;
            pixelColor = lerp(pixelColor, float4((g_tFogCubeTexture.SampleLevel(g_tFogCubeTexture_s, normalize(mul(float4(cameraCenteredPixelPos, 0.0f), g_matvCubeFogSkyWsToOs).xyz), g_vCubeFog_Height_Offset_Scale_Exponent_Log2Mip.w * clamp(mad(-_16990, g_vCubeFog_Offset_Scale_Bias_Exponent.z, 1.0f), 0.0f, 1.0f)) * g_vCubeFog_ExposureBias.x).xyz, _8437).xyz, _8437.xxx);
        }
    }
}
