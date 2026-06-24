import React from 'react'
import Students from './Students'

const Home = () => {
    return (
        <div className="min-h-screen bg-gradient-to-r from-slate-900 to-slate-700 text-white">
            {/* Navbar */}
            <nav className="flex items-center justify-between px-8 py-5">
                <h1 className="text-2xl font-bold">MySite</h1>

                <div className="space-x-6 text-sm">
                    <a href="#" className="hover:text-gray-300">
                        Home
                    </a>
                    <a href="#" className="hover:text-gray-300">
                        About
                    </a>
                    <a href="#" className="hover:text-gray-300">
                        Contact
                    </a>
                </div>
            </nav>

            {/* Hero Section */}
            <div className="flex flex-col items-center justify-center text-center px-6 mt-32">
                <h2 className="text-5xl font-extrabold mb-6">
                    Build Something Amazing!! BOOOOOOO!
                </h2>

                <p className="text-lg text-gray-300 max-w-2xl mb-8">
                    A clean and modern static homepage built with React and Tailwind CSS.
                </p>
                <Students></Students>
            </div>
        </div>
    )
}

export default Home