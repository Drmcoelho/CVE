import { useState, useEffect } from 'react'
import Head from 'next/head'

export default function Home() {
  const [currentBrowser, setCurrentBrowser] = useState('')
  const [isCodespaceEnv, setIsCodespaceEnv] = useState(false)

  useEffect(() => {
    // Detect browser for optimization
    const userAgent = navigator.userAgent
    if (userAgent.includes('Safari') && !userAgent.includes('Chrome')) {
      setCurrentBrowser('Safari')
    } else if (userAgent.includes('Chrome')) {
      setCurrentBrowser('Chrome')
    } else if (userAgent.includes('Edg')) {
      setCurrentBrowser('Edge')
    } else {
      setCurrentBrowser('Other')
    }

    // Detect Codespace environment
    setIsCodespaceEnv(window.location.hostname.includes('github.dev') || 
                      window.location.hostname.includes('codespaces'))
  }, [])

  const optimizationTips = {
    Safari: [
      'Enable WebGL for better performance',
      'Use Safari Technology Preview for latest features',
      'Optimize for iOS devices with touch interactions'
    ],
    Chrome: [
      'Enable hardware acceleration',
      'Use Chrome DevTools for debugging',
      'Leverage Chrome extensions for development'
    ],
    Edge: [
      'Use Edge DevTools with enhanced debugging',
      'Optimize for Windows integration',
      'Leverage Microsoft ecosystem features'
    ],
    Other: [
      'Use standard web APIs for compatibility',
      'Test across multiple browsers',
      'Focus on progressive enhancement'
    ]
  }

  return (
    <>
      <Head>
        <title>CVE Course - AI-Powered Cybersecurity Education</title>
        <meta name="description" content="Comprehensive CVE course with AI automation, multi-platform support, and intelligent content generation" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <link rel="icon" href="/favicon.ico" />
      </Head>

      <div className="min-h-screen bg-gradient-to-br from-blue-900 via-purple-900 to-indigo-900">
        <div className="container mx-auto px-4 py-8">
          {/* Header */}
          <header className="text-center mb-12">
            <h1 className="text-5xl font-bold text-white mb-4">
              CVE Course Platform
            </h1>
            <p className="text-xl text-blue-200 mb-6">
              AI-Powered Cybersecurity Vulnerability Education
            </p>
            
            {/* Environment Info */}
            <div className="flex justify-center space-x-4 mb-8">
              <span className={`px-4 py-2 rounded-full text-sm font-medium ${
                isCodespaceEnv 
                  ? 'bg-green-600 text-white' 
                  : 'bg-yellow-600 text-white'
              }`}>
                {isCodespaceEnv ? '🚀 Codespace' : '💻 Local'}
              </span>
              <span className="px-4 py-2 bg-blue-600 text-white rounded-full text-sm font-medium">
                🌐 {currentBrowser}
              </span>
            </div>
          </header>

          {/* Main Features Grid */}
          <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-8 mb-12">
            {/* AI Integration */}
            <div className="bg-white/10 backdrop-blur-md rounded-lg p-6 border border-white/20">
              <div className="text-3xl mb-4">🤖</div>
              <h3 className="text-xl font-semibold text-white mb-3">AI Integration</h3>
              <ul className="text-blue-200 space-y-2">
                <li>• GitHub Copilot integration</li>
                <li>• Gemini CLI automation</li>
                <li>• OpenAI content generation</li>
                <li>• LLM-to-LLM interactions</li>
              </ul>
            </div>

            {/* Multi-Platform Support */}
            <div className="bg-white/10 backdrop-blur-md rounded-lg p-6 border border-white/20">
              <div className="text-3xl mb-4">🌐</div>
              <h3 className="text-xl font-semibold text-white mb-3">Multi-Platform</h3>
              <ul className="text-blue-200 space-y-2">
                <li>• GitHub Codespaces</li>
                <li>• SSH access</li>
                <li>• Web interface</li>
                <li>• Cross-browser optimization</li>
              </ul>
            </div>

            {/* Automation */}
            <div className="bg-white/10 backdrop-blur-md rounded-lg p-6 border border-white/20">
              <div className="text-3xl mb-4">⚡</div>
              <h3 className="text-xl font-semibold text-white mb-3">Automation</h3>
              <ul className="text-blue-200 space-y-2">
                <li>• Continuous integration</li>
                <li>• Automated deployment</li>
                <li>• Content generation</li>
                <li>• Performance monitoring</li>
              </ul>
            </div>

            {/* Course Content */}
            <div className="bg-white/10 backdrop-blur-md rounded-lg p-6 border border-white/20">
              <div className="text-3xl mb-4">📚</div>
              <h3 className="text-xl font-semibold text-white mb-3">Course Content</h3>
              <ul className="text-blue-200 space-y-2">
                <li>• CVE database analysis</li>
                <li>• Vulnerability assessment</li>
                <li>• Security best practices</li>
                <li>• Hands-on labs</li>
              </ul>
            </div>

            {/* Interactive Learning */}
            <div className="bg-white/10 backdrop-blur-md rounded-lg p-6 border border-white/20">
              <div className="text-3xl mb-4">🎯</div>
              <h3 className="text-xl font-semibold text-white mb-3">Interactive Learning</h3>
              <ul className="text-blue-200 space-y-2">
                <li>• Real-time coding</li>
                <li>• AI-powered feedback</li>
                <li>• Progress tracking</li>
                <li>• Adaptive learning</li>
              </ul>
            </div>

            {/* Deployment */}
            <div className="bg-white/10 backdrop-blur-md rounded-lg p-6 border border-white/20">
              <div className="text-3xl mb-4">🚀</div>
              <h3 className="text-xl font-semibold text-white mb-3">Deployment</h3>
              <ul className="text-blue-200 space-y-2">
                <li>• GitHub Pages</li>
                <li>• Container support</li>
                <li>• CI/CD pipeline</li>
                <li>• Scalable architecture</li>
              </ul>
            </div>
          </div>

          {/* Browser Optimization Section */}
          <div className="bg-white/10 backdrop-blur-md rounded-lg p-8 mb-12 border border-white/20">
            <h2 className="text-2xl font-bold text-white mb-6">
              🎯 Optimizations for {currentBrowser}
            </h2>
            <div className="grid md:grid-cols-2 gap-6">
              <div>
                <h3 className="text-lg font-semibold text-blue-200 mb-3">Recommendations:</h3>
                <ul className="text-white space-y-2">
                  {optimizationTips[currentBrowser as keyof typeof optimizationTips]?.map((tip, index) => (
                    <li key={index} className="flex items-start">
                      <span className="text-green-400 mr-2">✓</span>
                      {tip}
                    </li>
                  ))}
                </ul>
              </div>
              <div>
                <h3 className="text-lg font-semibold text-blue-200 mb-3">Performance:</h3>
                <div className="space-y-2">
                  <div className="flex justify-between text-white">
                    <span>Loading Speed</span>
                    <span className="text-green-400">Excellent</span>
                  </div>
                  <div className="flex justify-between text-white">
                    <span>Compatibility</span>
                    <span className="text-green-400">Optimized</span>
                  </div>
                  <div className="flex justify-between text-white">
                    <span>Features</span>
                    <span className="text-blue-400">Enhanced</span>
                  </div>
                </div>
              </div>
            </div>
          </div>

          {/* Quick Start */}
          <div className="bg-white/10 backdrop-blur-md rounded-lg p-8 border border-white/20">
            <h2 className="text-2xl font-bold text-white mb-6">🚀 Quick Start</h2>
            <div className="grid md:grid-cols-2 gap-8">
              <div>
                <h3 className="text-lg font-semibold text-blue-200 mb-3">Via GitHub Codespaces:</h3>
                <pre className="bg-black/30 p-4 rounded text-green-400 text-sm overflow-x-auto">
{`# Click "Code" → "Codespaces" → "Create codespace"
# Environment auto-configures with all tools

gh auth login
gh copilot suggest "create CVE module"
python scripts/ai_automation.py`}
                </pre>
              </div>
              <div>
                <h3 className="text-lg font-semibold text-blue-200 mb-3">Via SSH/Local:</h3>
                <pre className="bg-black/30 p-4 rounded text-green-400 text-sm overflow-x-auto">
{`git clone <repository-url>
cd CVE
npm install
npm run setup-env
npm run dev`}
                </pre>
              </div>
            </div>
          </div>
        </div>
      </div>
    </>
  )
}