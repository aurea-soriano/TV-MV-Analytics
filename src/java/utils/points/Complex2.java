/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package utils.points;

/**
 *
 * @author aurea
 */
public class Complex2 {
    private final double re;   // the real part
    private final double im;   // the imaginary part

    // create a new object with the given real and imaginary parts
    public Complex2(double real, double imag) {
        re = real;
        im = imag;
    }

    // return a string representation of the invoking Complex object
    @Override
    public String toString() {
        if (im == 0) return re + "";
        if (re == 0) return im + "i";
        if (im <  0) return re + " - " + (-im) + "i";
        return re + " + " + im + "i";
    }

    // return abs/modulus/magnitude and angle/phase/argument
    public double abs()   { return Math.hypot(re, im); }  // Math.sqrt(re*re + im*im)
    public double phase() { return Math.atan2(im, re); }  // between -pi and pi

    // return a new Complex object whose value is (this + b)
    public Complex2 plus(Complex2 b) {
        Complex2 a = this;             // invoking object
        double real = a.re + b.re;
        double imag = a.im + b.im;
        return new Complex2(real, imag);
    }

    // return a new Complex object whose value is (this - b)
    public Complex2 minus(Complex2 b) {
        Complex2 a = this;
        double real = a.re - b.re;
        double imag = a.im - b.im;
        return new Complex2(real, imag);
    }

    // return a new Complex object whose value is (this * b)
    public Complex2 times(Complex2 b) {
        Complex2 a = this;
        double real = a.re * b.re - a.im * b.im;
        double imag = a.re * b.im + a.im * b.re;
        return new Complex2(real, imag);
    }

    // scalar multiplication
    // return a new object whose value is (this * alpha)
    public Complex2 times(double alpha) {
        return new Complex2(alpha * re, alpha * im);
    }

    // return a new Complex object whose value is the conjugate of this
    public Complex2 conjugate() {  return new Complex2(re, -im); }

    // return a new Complex object whose value is the reciprocal of this
    public Complex2 reciprocal() {
        double scale = re*re + im*im;
        return new Complex2(re / scale, -im / scale);
    }

    // return the real or imaginary part
    public double re() { return re; }
    public double im() { return im; }

    // return a / b
    public Complex2 divides(Complex2 b) {
        Complex2 a = this;
        return a.times(b.reciprocal());
    }

    // return a new Complex object whose value is the complex exponential of this
    public Complex2 exp() {
        return new Complex2(Math.exp(re) * Math.cos(im), Math.exp(re) * Math.sin(im));
    }

    // return a new Complex object whose value is the complex sine of this
    public Complex2 sin() {
        return new Complex2(Math.sin(re) * Math.cosh(im), Math.cos(re) * Math.sinh(im));
    }

    // return a new Complex object whose value is the complex cosine of this
    public Complex2 cos() {
        return new Complex2(Math.cos(re) * Math.cosh(im), -Math.sin(re) * Math.sinh(im));
    }

    // return a new Complex object whose value is the complex tangent of this
    public Complex2 tan() {
        return sin().divides(cos());
    }
    


    // a static version of plus
    public static Complex2 plus(Complex2 a, Complex2 b) {
        double real = a.re + b.re;
        double imag = a.im + b.im;
        Complex2 sum = new Complex2(real, imag);
        return sum;
    }



    // sample client for testing
    public static void main(String[] args) {
        Complex2 a = new Complex2(5.0, 6.0);
        Complex2 b = new Complex2(-3.0, 4.0);

        System.out.println("a            = " + a);
        System.out.println("b            = " + b);
        System.out.println("Re(a)        = " + a.re());
        System.out.println("Im(a)        = " + a.im());
        System.out.println("b + a        = " + b.plus(a));
        System.out.println("a - b        = " + a.minus(b));
        System.out.println("a * b        = " + a.times(b));
        System.out.println("b * a        = " + b.times(a));
        System.out.println("a / b        = " + a.divides(b));
        System.out.println("(a / b) * b  = " + a.divides(b).times(b));
        System.out.println("conj(a)      = " + a.conjugate());
        System.out.println("|a|          = " + a.abs());
        System.out.println("tan(a)       = " + a.tan());
    }

}
