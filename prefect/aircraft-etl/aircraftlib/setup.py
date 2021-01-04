from setuptools import setup, find_packages

packages = find_packages()

with open("requirements.txt") as fp:
    dependencies = fp.readlines()

setup(
    name="aircraftlib",
    version="1.0",
    description="Aircraf Lib",
    author="Pedro Martins",
    author_email="pedro@datarevenue.com",
    install_requires= dependencies,
    packages=packages,
    zip_safe=False,
    include_package_data=True,
)