import helpers

def transfer():
    print("Starting transfer of list")
    targets = helpers.read_target_csv()
    helpers.append_to_prod_list(targets)
    print("Finished transfer of list")

if __name__ == "__main__":
    transfer()