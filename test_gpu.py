import torch
def main():
    device = torch.device("cuda:0" if (torch.cuda.is_available()) else "cpu")

    print ("Hello world from", device)
if __name__ == "__main__":
    main()