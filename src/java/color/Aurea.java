/*
 * To change this license headerf, choose License Headers in Project Properties.
 * To change this template filef, choose Tools | Templates
 * and open the template in the editor.
 */
package color;

import java.awt.Color;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.imageio.ImageIO;
import utils.ColorScale;

/**
 *
 * @author aurea
 */
public class Aurea implements ColorScale {

    @Override
    public Color[] getColorScale() {
        Color[] rgb;
        rgb = new Color[11];

        rgb[0] = new Color(92, 138, 168);
        rgb[1] = new Color(209, 26, 66);
        rgb[2] = new Color(140, 181, 0);
        rgb[3] = new Color(255, 117, 23);
        rgb[4] = new Color(128, 69, 28);
        rgb[5] = new Color(255, 217, 0);
        rgb[6] = new Color(0, 130, 128);
        rgb[7] = new Color(199, 8, 20);
        rgb[8] = new Color(115, 135, 120);
        rgb[9] = new Color(0, 20, 168);
        rgb[10] = new Color(255, 161,138); 
        	
        
        return rgb;

    }
    
    public BufferedImage getBufferedImage() {

        Color[] scale = this.getColorScale();
        BufferedImage b = new BufferedImage(scale.length, 10, 3);

        System.out.println(b.getHeight());
        for (int x = 0; x < scale.length; x++) {
            int rgb = scale[x].getRGB();
            for (int y = 0; y < 10; y++) {
                b.setRGB(x, y, rgb);
            }
        }

        return b;

    }

    public static void main(String[] args) {

        try {
            Aurea aurea = new Aurea();
            ImageIO.write(aurea.getBufferedImage(), "png", new File("/home/aurea/results/scale_aurea.png"));
        } catch (IOException ex) {
            Logger.getLogger(PseudoRainbow.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
}

