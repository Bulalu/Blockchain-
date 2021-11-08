from brownie import *

def main():
    print("Hello World")
    Token.deploy("Test Token", "TEST", 18, 1e23, {'from':accounts[0]})
