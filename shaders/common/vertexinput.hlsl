// Common Vertex Shader Attributes

float3 vPositionOs : POSITION < Semantic( PosXyz ); >;
float2 vTexCoord : TEXCOORD0 < Semantic( LowPrecisionUv ); >;

#if (D_COMPRESSED_NORMALS_AND_TANGENTS == 0)
    float3 vNormalOs                  : NORMAL  < Semantic( Normal ); >;
    float3 vTangentUOs_flTangentVSign : TANGENT < Semantic( TangentU_SignV ); >;
#elif (D_COMPRESSED_NORMALS_AND_TANGENTS == 1)
    uint vNormalOs  : NORMAL < Semantic( PackedFrame ); >;
#endif

#if (D_SKINNING == 1)
    uint4 vBlendIndices : BLENDINDICES < Semantic( BlendIndices ); >;
    float4 vBlendWeight : BLENDWEIGHT  < Semantic( BlendWeight ); >;
#endif

#if (D_MORPH == 1)
	float nVertexIndex : TEXCOORD14 < Semantic( MorphIndex ); >;
#endif

//-------------------------------------------------------------------------------------------------------------------------------------------------------------
// Instancing data
//-------------------------------------------------------------------------------------------------------------------------------------------------------------
uint nTransformBufferOffset : TEXCOORD13 < Semantic( InstanceTransformUv ); >;

//-------------------------------------------------------------------------------------------------------------------------------------------------------------
// Baked lighting
//-------------------------------------------------------------------------------------------------------------------------------------------------------------
#if ( D_BAKED_LIGHTING_FROM_LIGHTMAP )	
	float2 vLightmapUV : TEXCOORD3 < Semantic( LightmapUV ); > ;
#endif	
	
#if ( D_BAKED_LIGHTING_FROM_VERTEX_STREAM )	 
	float4 vPerVertexLighting : COLOR1 < Semantic( PerVertexLighting ); > ;
#endif
