cbuffer PerViewConstantBufferCsgo_t : register(b18, space0)
{
    bool4 g_bFogTypeEnabled;
    bool4 g_bOtherFxEnabled;
    bool4 g_bOtherEnabled2;

    // Bindless texture indices
    uint g_tBlueNoiseTextureIndex;
    uint g_tBRDFLookupTextureIndex;
    uint g_tCubemapFogTextureIndex;
    uint g_tDynamicAmbientOcclusionTextureIndex;
    uint g_tDynamicAmbientOcclusionDepthIndex;
    uint g_tSSAOIndex;
    uint g_tParticleShadowBufferIndex;
    uint g_tZeroth_MomentIndex;
    uint g_tMomentsIndex;
    uint g_tExtra_MomentIndex;
    uint g_tLowShaderQualityFallbackCubemap;

    uint g_tUnused0;
    float2 g_vBlueNoiseMask;
    uint g_tUnused1;
    uint g_tUnused2;
    column_major float4x4 g_matSkyboxToWorld;
    float2 g_vAoProxyDepthInvTextureSize;
    float g_flAoProxyDownres;
    float g_flUnusedAfterAo;
    float4 g_vWindDirection;
    float4 g_vWindStrengthFreqMulHighStrength;
    float4 g_vInteractionProjectionOrigin;
    float4 g_vInteractionVolumeInvExtents;
    float4 g_vInteractionTriggerVolumeInvMins;
    float4 g_vInteractionTriggerVolumeWorldToVolumeScale;
    float4 g_vGradientFogBiasAndScale : packoffset(c18);
    float4 m_vGradientFogExponents : packoffset(c19);
    float4 g_vGradientFogColor_Opacity : packoffset(c20);
    float4 g_vGradientFogCullingParams : packoffset(c21);
    float4 g_vCubeFog_Offset_Scale_Bias_Exponent : packoffset(c22);
    float4 g_vCubeFog_Height_Offset_Scale_Exponent_Log2Mip : packoffset(c23);
    column_major float4x4 g_matvCubeFogSkyWsToOs : packoffset(c24);
    float4 g_vCubeFogCullingParams_MaxOpacity : packoffset(c28);
    float4 g_vCubeFog_ExposureBias : packoffset(c29);
    float4 g_vHighPrecisionLightingOffsetWs : packoffset(c30);
    float g_flEnvMapPositionBias;
    float g_flScopeMagnification;
    float g_flEffectStrength;
    float g_flMixedResolutionViewportScale;
    float g_flMBOIT_Overestimation;
    float g_flMBOIT_Bias;
    float g_flMBOIT_Scale;
    float g_flToolsVisCubemapReflectionRoughness;
    float g_flCablePixelRadiusScale;
    float g_flRealTime;
    float g_flBeginMixingRoughness;
};
