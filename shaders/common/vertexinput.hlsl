#if (D_SKINNING == 1)
    float4 vBlendIndices          : BLENDINDICES0  < Semantic( BlendIndices ); >;
    float4 vBlendWeight           : BLENDWEIGHT0   < Semantic( BlendWeight ); >;
#endif

#if (D_COMPRESSED_NORMALS_AND_TANGENTS == 0)
    float3 vNormalOs                : NORMAL0        < Semantic( Normal ); >;
    float3 vTangentOs               : TANGENT0       < Semantic( Tangent ); >;
#elif (D_COMPRESSED_NORMALS_AND_TANGENTS == 1)
    uint vNormalOs                : NORMAL0        < Semantic( CompressedTangentFrame ); >;
#endif

float3 vPositionOs            : POSITION0      < Semantic( PosXyz ); >;
float2 vTexCoord              : TEXCOORD0      < Semantic( LowPrecisionUv ); >;
float2 nTransformBufferOffset : TEXCOORD13     < Semantic( InstanceTransformUv ); >;
