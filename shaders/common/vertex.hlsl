
DynamicCombo( D_SKINNING, 0..1, Sys(ALL));
DynamicCombo( D_COMPRESSED_NORMALS_AND_TANGENTS, 0..1, Sys(ALL));

#include "common/instancing.hlsl"

void VS_DecodeObjectSpaceNormalAndTangent(VS_INPUT i, out float3 vNormalOs, out float4 vTangentUOs_flTangentVSign)
{
    #if (D_COMPRESSED_NORMALS_AND_TANGENTS == 0)
        vNormalOs = i.vNormalOs;
        vTangentUOs_flTangentVSign = i.vTangentUOs_flTangentVSign;
    #elif (D_COMPRESSED_NORMALS_AND_TANGENTS == 1)
        //DecodeNormalTangent(i.vNormalOs);
    #endif
}

PS_INPUT ProcessVertex(VS_INPUT i)
{
    float3 vNormalOs;
    float4 vTangentUOs_flTangentVSign;

    VS_DecodeObjectSpaceNormalAndTangent(i, vNormalOs, vTangentUOs_flTangentVSign);
}
