import numpy as np
import matplotlib.pyplot as plt

def poly_short(x: float) -> float:
    return (x - 5)**8

def ply_long(x: float) -> float:
    return (x**8 - 40 * x**7 + 700*x**6 - 7000 * x**5 + 43750 * x**4 - 175000 * x**3 + 437500 * x**2 - 625000 * x + 390625)

if __name__=="__main__":
    x = np.linspace(4.0, 6.0, 201)
    y_short = poly_short(x)
    y_long = ply_long(x)
    roundoff = np.abs(y_long - y_short) / np.abs(y_long)
    
    # Plot the roundoff error using a log scale
    plt.plot(x, roundoff)
    plt.yscale('log')
    plt.xlabel('x')
    plt.ylabel('Relative Error')
    plt.title('Relative error of the short polynomial approximation')
    plt.show()

    