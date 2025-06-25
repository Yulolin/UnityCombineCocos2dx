#include "RenderAPI.h"
#include "PlatformBase.h"
#include "cocos2d.h"

// OpenGL Core profile (desktop) or OpenGL ES (mobile) implementation of RenderAPI.
// Supports several flavors: Core, ES2, ES3


#include <assert.h>
#include <ES2/gl.h>


class RenderAPI_OpenGLES2 : public RenderAPI
{
public:
	RenderAPI_OpenGLES2(UnityGfxRenderer apiType);
	virtual ~RenderAPI_OpenGLES2() { }

	virtual void ProcessDeviceEvent(UnityGfxDeviceEventType type, IUnityInterfaces* interfaces);

	virtual bool GetUsesReverseZ() { return false; }

	virtual void DrawSimpleTriangles(const float worldMatrix[16], int triangleCount, const void* verticesFloat3Byte4);
    
private:
	void CreateResources();

private:
	UnityGfxRenderer m_APIType;
	GLuint m_VertexShader;
	GLuint m_FragmentShader;
	GLuint m_Program;
	GLuint m_VertexArray;
	GLuint m_VertexBuffer;
	int m_UniformWorldMatrix;
	int m_UniformProjMatrix;
};


RenderAPI* CreateRenderAPI_OpenGLES2(UnityGfxRenderer apiType)
{
	return new RenderAPI_OpenGLES2(apiType);
}


enum VertexInputs
{
	kVertexInputPosition = 0,
	kVertexInputColor = 1
};


// Simple vertex shader source
#define VERTEX_SHADER_SRC(ver, attr, varying)						\
	ver																\
	attr " highp vec3 pos;\n"										\
	attr " lowp vec4 color;\n"										\
	"\n"															\
	varying " lowp vec4 ocolor;\n"									\
	"\n"															\
	"uniform highp mat4 worldMatrix;\n"								\
	"uniform highp mat4 projMatrix;\n"								\
	"\n"															\
	"void main()\n"													\
	"{\n"															\
	"	gl_Position = (projMatrix * worldMatrix) * vec4(pos,1);\n"	\
	"	ocolor = color;\n"											\
	"}\n"															\

static const char* kGlesVProgTextGLES2 = VERTEX_SHADER_SRC("\n", "attribute", "varying");

// Simple fragment shader source
#define FRAGMENT_SHADER_SRC(ver, varying, outDecl, outVar)	\
	ver												\
	outDecl											\
	varying " lowp vec4 ocolor;\n"					\
	"\n"											\
	"void main()\n"									\
	"{\n"											\
	"	" outVar " = ocolor;\n"						\
	"}\n"											\

static const char* kGlesFShaderTextGLES2 = FRAGMENT_SHADER_SRC("\n", "varying", "\n", "gl_FragColor");

static GLuint CreateShader(GLenum type, const char* sourceText)
{
	GLuint ret = glCreateShader(type);
	glShaderSource(ret, 1, &sourceText, NULL);
	glCompileShader(ret);
	return ret;
}


void RenderAPI_OpenGLES2::CreateResources()
{
	// Make sure that there are no GL error flags set before creating resources
//	while (glGetError() != GL_NO_ERROR) {}
//
//	// Create shaders
//    m_VertexShader = CreateShader(GL_VERTEX_SHADER, kGlesVProgTextGLES2);
//    m_FragmentShader = CreateShader(GL_FRAGMENT_SHADER, kGlesFShaderTextGLES2);
//    
//	// Link shaders into a program and find uniform locations
//	m_Program = glCreateProgram();
//	glBindAttribLocation(m_Program, kVertexInputPosition, "pos");
//	glBindAttribLocation(m_Program, kVertexInputColor, "color");
//	glAttachShader(m_Program, m_VertexShader);
//	glAttachShader(m_Program, m_FragmentShader);
//    
//	glLinkProgram(m_Program);
//
//	GLint status = 0;
//	glGetProgramiv(m_Program, GL_LINK_STATUS, &status);
//	assert(status == GL_TRUE);
//
//	m_UniformWorldMatrix = glGetUniformLocation(m_Program, "worldMatrix");
//	m_UniformProjMatrix = glGetUniformLocation(m_Program, "projMatrix");
//
//	// Create vertex buffer
//	glGenBuffers(1, &m_VertexBuffer);
//	glBindBuffer(GL_ARRAY_BUFFER, m_VertexBuffer);
//	glBufferData(GL_ARRAY_BUFFER, 1024, NULL, GL_STREAM_DRAW);
//
//	assert(glGetError() == GL_NO_ERROR);
    
//    auto director = cocos2d::Director::getInstance();
//    auto glview = director->getOpenGLView();
//    if (!glview)
//    {
//        glview = cocos2d::GLViewImpl::create("Android app");
//        glview->setFrameSize(500, 500);
//        director->setOpenGLView(glview);
//
//        cocos2d::Application::getInstance()->run();
//    }
    
    
}


RenderAPI_OpenGLES2::RenderAPI_OpenGLES2(UnityGfxRenderer apiType)
	: m_APIType(apiType)
{
}


void RenderAPI_OpenGLES2::ProcessDeviceEvent(UnityGfxDeviceEventType type, IUnityInterfaces* interfaces)
{
	if (type == kUnityGfxDeviceEventInitialize)
	{
		CreateResources();
	}
	else if (type == kUnityGfxDeviceEventShutdown)
	{
		//@TODO: release resources
	}
}


void RenderAPI_OpenGLES2::DrawSimpleTriangles(const float worldMatrix[16], int triangleCount, const void* verticesFloat3Byte4)
{
//    cocos2d::Director::getInstance()->mainLoop();
	// Set basic render state
	glDisable(GL_CULL_FACE);
	glDisable(GL_BLEND);
	glDepthFunc(GL_LEQUAL);
	glEnable(GL_DEPTH_TEST);
	glDepthMask(GL_FALSE);

	// Tweak the projection matrix a bit to make it match what identity projection would do in D3D case.
	float projectionMatrix[16] = {
		1,0,0,0,
		0,1,0,0,
		0,0,2,0,
		0,0,-1,1,
	};

	// Setup shader program to use, and the matrices
	glUseProgram(m_Program);
	glUniformMatrix4fv(m_UniformWorldMatrix, 1, GL_FALSE, worldMatrix);
	glUniformMatrix4fv(m_UniformProjMatrix, 1, GL_FALSE, projectionMatrix);

	// Bind a vertex buffer, and update data in it
	const int kVertexSize = 12 + 4;
	glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);
	glBindBuffer(GL_ARRAY_BUFFER, m_VertexBuffer);
	glBufferSubData(GL_ARRAY_BUFFER, 0, kVertexSize * triangleCount * 3, verticesFloat3Byte4);

	// Setup vertex layout
	glEnableVertexAttribArray(kVertexInputPosition);
	glVertexAttribPointer(kVertexInputPosition, 3, GL_FLOAT, GL_FALSE, kVertexSize, (char*)NULL + 0);
	glEnableVertexAttribArray(kVertexInputColor);
	glVertexAttribPointer(kVertexInputColor, 4, GL_UNSIGNED_BYTE, GL_TRUE, kVertexSize, (char*)NULL + 12);

	// Draw
	glDrawArrays(GL_TRIANGLES, 0, triangleCount * 3);
    
//    cocos2d::Director::getInstance()->mainLoop();
    
}
