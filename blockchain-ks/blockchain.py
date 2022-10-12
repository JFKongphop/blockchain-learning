import datetime, json, hashlib
from flask import Flask, jsonify

class Blockchain:
    def __init__(self):
        # get block group
        self.chain = []

        # genesis block or first block
        self.createBlock(nonce = 1, previous_hash = "0")

    # method create block
    def createBlock(self, nonce, previous_hash):
        # collect element in block each block
        block = {
            "index" : len(self.chain) + 1,
            "timestamp" : str(datetime.datetime.now()),
            "nonce" : nonce,
            "previous_hash" : previous_hash
        }
         
        # connect the block
        self.chain.append(block)
        return block

    # use latest block
    def get_previous_block(self):
        return self.chain[-1]

    # hash block
    def hash(self, block):
        # sort data in block and convert dict to json object
        encode_block = json.dumps(block, sort_keys=True).encode()

        # sha-256
        return hashlib.sha256(encode_block).hexdigest()
    
    # find nonce by POW
    def proof_of_work(self, previous_nonce):
        # find nonce that is target hash such as first 4 digit 0000xxxxx
        new_nonce = 1 # initial nonce
        check_proof = False

        # solve mathematics
        while check_proof is False:
            # encode and change to binary 16 to find nonce of block difficult
            hashoperation = hashlib.sha256(str(pow(new_nonce, 2) - pow(previous_nonce, 2)).encode()).hexdigest()
            if hashoperation[:4] == "0000":
                check_proof = True
            
            # that plus more nonce to check
            else:
                new_nonce += 1

        return new_nonce      

    # check block in the blockchain
    def is_chain_valid(self, chain):
        previous_block = chain[0]
        block_index = 1

        while block_index < len(chain):
            block = chain[block_index] # check block at
            
            # if it not equal to is False chain is cut out
            if block["previous_hash"] != self.hash(previous_block):
                return False
            
            # check it equla
            previous_nonce = previous_block["nonce"]# nonce previous block
            nonce = block["nonce"] # check nonce
            hashoperation = hashlib.sha256(str(pow(nonce, 2) - pow(previous_nonce, 2)).encode()).hexdigest() # check next block again

            if hashoperation[:4] != "0000":
                return False
            
            # when finish check to next block
            previous_block = block
            block_index += 1
        
        return True

# web Flask
app = Flask(__name__)

# use blockchain
blockchain = Blockchain()

#routing
@app.route('/')
def hello():
    return "<h1>Hello Blockchain</h1>"
 
# get chain to show
@app.route('/get_chain', methods=["GET"])
def get_chain():
    response = {
        "chain" : blockchain.chain,
        "length" : len(blockchain.chain)
    }

    return jsonify(response), 200

# mining methods
@app.route('/mining', methods=["GET"])
def mining_block():
    # pow
    # get previous block to calculate
    previous_block = blockchain.get_previous_block()
    previous_nonce = previous_block["nonce"]

    # nonce
    nonce = blockchain.proof_of_work(previous_nonce)

    # get hash previous block
    previous_hash = blockchain.hash(nonce)
    
    # update block new
    block = blockchain.createBlock(nonce, previous_hash)

    response = {
        "message" : "Mining Block is Done!!!",
        "index" : block["index"],
        "timestamp" : block["timestamp"],
        "nonce" : block["nonce"],
        "previous_hash" : block["previous_hash"]
    }

    return jsonify(response), 200


# check all block
@app.route('/is_valid',methods=["GET"])
def is_valid():
    is_valid = blockchain.is_chain_valid(blockchain.chain)

    if is_valid:
        response={"message" : "Blockchain Is Valid"}
    else :
        response={"message" : "Have Problem , Blockchain Is InValid"}
        
    return jsonify(response),200

# run server
if __name__ == "__main__":
    app.run()