struct TransformData_t
{
    row_major float3x4 mTransform ;
};

struct PerInstancePackedShaderData_t
{
    uint PackedData[8];
};

StructuredBuffer<TransformData_t> g_transformBuffer : register(t30, space2) < Attribute("TransformBuffer"); >;
StructuredBuffer<PerInstancePackedShaderData_t> g_instanceBuffer : register(t32, space2) < Attribute("InstanceBuffer"); >; 

float3x4 CalculateInstancingObjectToWorldMatrix(uint nInstanceIndex)
{
    TransformData_t transformData = g_transformBuffer[nInstanceIndex];
    return transformData.mTransform;
}

float4 UnpackTintColorRGBA32(uint nColor)
{
    float4 vResult;
    vResult.a = (nColor >> 24);
    vResult.b = (nColor >> 16) & 0xff;
    vResult.g = (nColor >> 8) & 0xff;
    vResult.r = (nColor >> 0) & 0xff;
    vResult.rgba *= ( 1 / 255.f );
    //vResult.rgb = SrgbGammaToLinear(vResult.rgb);
    return vResult;
}

struct InstanceData_t
{
    float4 vTint;
};

InstanceData_t DecodePackedInstanceData(PerInstancePackedShaderData_t packedData)
{
    InstanceData_t extraShaderData;
    extraShaderData.vTint = UnpackTintColorRGBA32(packedData.m_Data[0]);
    return extraShaderData;
}
