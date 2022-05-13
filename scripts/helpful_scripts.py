from brownie import network, accounts,config,MockV3Aggregator
from web3 import Web3

DECIMALS=8
STARTING_PRICE=200000000000

FORKED_LOCAL_ENVIRONMENTS=["mainnet-fork"]
LOCAL_BLOCKCHAIN_ENVIRONMENTS=["development","ganache-local"]

def get_account():
    if network.show_active() in LOCAL_BLOCKCHAIN_ENVIRONMENTS:
        return accounts[0]
    else:
        return accounts.add(config["wallets"]["from_key"])

def deploy_mocks():
    print(f"the network is {network.show_active()}")
    print("Deploying Mocks")
    if len(MockV3Aggregator)<=0:
        # mock_aggregator=MockV3Aggregator.deploy(8,200000000000,{"from":account})
        # price_feed_address=mock_aggregator.address
        #The below lines are same as the above lines
        MockV3Aggregator.deploy(DECIMALS,STARTING_PRICE,{"from":get_account()})
    print("Mocks deployed")