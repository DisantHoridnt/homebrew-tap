from setuptools import setup, find_packages

setup(
    name="claude_engineer",
    version="0.1",
    packages=find_packages(),
    include_package_data=True,
    install_requires=[
        'colorama',
        'pygments',
        'tavily',
        'anthropic',
        'Pillow',
    ],
    entry_points={
        'console_scripts': [
            'claude-engineer=claude_engineer.main:main',
        ],
    },
    author="Disant Upadhyay",
    author_email="disantupadhyay07@gmail.com",
    description="Claude Engineer CLI Tool",
    long_description=open('README.md').read(),
    long_description_content_type='text/markdown',
    url="https://github.com/yourusername/cli-engineer",
    classifiers=[
        'Programming Language :: Python :: 3',
        'License :: OSI Approved :: MIT License',
        'Operating System :: OS Independent',
    ],
    python_requires='>=3.6',
)