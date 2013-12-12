const vec3 gamma = vec3(2.2);
const vec3 gammainverse = 1.0 / gamma;

const vec3 eyedir = vec3(0.0, 0.0, 1.0);

varying vec3 lightdirs[4];

struct PointLight
{
    vec3 position;
    vec3 color;
    float radius;
};


struct Material
{
    Image normalmap;
    Image specularmap;
    float shininess; // specular power, 0-255
};

extern vec3 ambientcolor;

extern Material material;

extern number numlights;
extern PointLight Lights[4];

#ifdef VERTEX

vec4 position(mat4 mvp_matrix, vec4 vertex)
{
    vec3 screenvertex = vec3(TransformMatrix * vertex);

    for (int i = 0; i < numlights; i += 1)
    {
        lightdirs[i] = (Lights[i].position - screenvertex) / Lights[i].radius; 
    }
    
    return mvp_matrix * vertex;
}

#endif


#ifdef PIXEL

vec4 effect(vec4 vcolor, Image texture, vec2 texcoord, vec2 pixcoord)
{
    vec4 finalcolor = vec4(ambientcolor * vcolor.rgb, 0.0);
    
    vec4 texcolor = Texel(texture, texcoord);
    texcolor.rgb = pow(texcolor.rgb, gamma); // do calculations in linear color space
    finalcolor.rgb *= texcolor.rgb; 

    vec3 normal = Texel(material.normalmap, texcoord).rgb;
    normal = normalize(NormalMatrix * (normal * 2.0 - 1.0));

    for (int i = 0; i < numlights; i += 1)
    {
        float lightintensity = max(1.0 - dot(lightdirs[i], lightdirs[i]), 0.0);
        lightintensity *= lightintensity;

        if (lightintensity > 0.0)
        {
            vec3 Ldir = normalize(lightdirs[i]);
            float diffuseamount = max(dot(normal, Ldir), 0.0);

            vec3 diffuse = vcolor.rgb * texcolor.rgb * diffuseamount;

            vec3 specularcolor = Texel(material.specularmap, texcoord).rgb;
            float specularbase = max(dot(normal, normalize(Ldir + eyedir)), 0.0);
            float specularamount = pow(specularbase, material.shininess);
            vec3 specular = specularcolor * specularamount;
        
            finalcolor.rgb += lightintensity * Lights[i].color * (diffuse + specular);
        }

        lightintensity = 0.0;
    }
    
    finalcolor.rgb = pow(finalcolor.rgb, gammainverse);
    finalcolor.a = texcolor.a * vcolor.a;
        
    return finalcolor;
}

#endif
