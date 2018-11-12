/*
 * To change this template, choose Tools | Templates
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
public class PseudoRainbow implements ColorScale {

    @Override
    public Color[] getColorScale() {
        Color[] rgb;
        rgb = new Color[256];

        rgb[0] = new Color(0.f, 0.f, 0.79999995f);
        rgb[1] = new Color(0.f, 0.f, 0.81725496f);
        rgb[2] = new Color(0.f, 0.f, 0.83450985f);
        rgb[3] = new Color(0.f, 0.f, 0.8517647f);
        rgb[4] = new Color(0.f, 0.f, 0.86901957f);
        rgb[5] = new Color(0.f, 0.f, 0.8862746f);
        rgb[6] = new Color(0.f, 0.f, 0.9035294f);
        rgb[7] = new Color(0.f, 0.f, 0.9207844f);
        rgb[8] = new Color(0.f, 0.f, 0.9380393f);
        rgb[9] = new Color(0.f, 0.f, 0.95529413f);
        rgb[10] = new Color(0.f, 0.f, 0.97254896f);
        rgb[11] = new Color(0.f, 0.f, 0.98980385f);
        rgb[12] = new Color(0.f, 0.007058859f, 1.f);
        rgb[13] = new Color(0.f, 0.024313688f, 1.f);
        rgb[14] = new Color(0.f, 0.041568756f, 0.99999994f);
        rgb[15] = new Color(0.f, 0.058823586f, 1.f);
        rgb[16] = new Color(0.f, 0.076078415f, 1.f);
        rgb[17] = new Color(0.f, 0.093333244f, 1.f);
        rgb[18] = new Color(0.f, 0.11058831f, 1.f);
        rgb[19] = new Color(0.f, 0.12784314f, 1.f);
        rgb[20] = new Color(0.f, 0.14509821f, 0.99999994f);
        rgb[21] = new Color(0.f, 0.16235304f, 1.f);
        rgb[22] = new Color(0.f, 0.17960787f, 1.f);
        rgb[23] = new Color(0.f, 0.1968627f, 1.f);
        rgb[24] = new Color(0.f, 0.21411753f, 1.f);
        rgb[25] = new Color(0.f, 0.2313726f, 1.f);
        rgb[26] = new Color(0.f, 0.24862742f, 1.f);
        rgb[27] = new Color(0.f, 0.2658825f, 0.99999994f);
        rgb[28] = new Color(0.f, 0.28313732f, 1.f);
        rgb[29] = new Color(0.f, 0.30039215f, 1.f);
        rgb[30] = new Color(0.f, 0.31764698f, 1.f);
        rgb[31] = new Color(0.f, 0.33490205f, 1.f);
        rgb[32] = new Color(0.f, 0.35215688f, 1.f);
        rgb[33] = new Color(0.f, 0.36941195f, 0.99999994f);
        rgb[34] = new Color(0.f, 0.38666677f, 1.f);
        rgb[35] = new Color(0.f, 0.4039216f, 1.f);
        rgb[36] = new Color(0.f, 0.42117643f, 1.f);
        rgb[37] = new Color(0.f, 0.4384315f, 1.f);
        rgb[38] = new Color(0.f, 0.45568633f, 1.f);
        rgb[39] = new Color(0.f, 0.47294116f, 1.f);
        rgb[40] = new Color(0.f, 0.49019623f, 0.99999994f);
        rgb[41] = new Color(0.f, 0.50745106f, 1.f);
        rgb[42] = new Color(0.f, 0.5247059f, 1.f);
        rgb[43] = new Color(0.f, 0.5419607f, 1.f);
        rgb[44] = new Color(0.f, 0.5592158f, 1.f);
        rgb[45] = new Color(0.f, 0.5764706f, 1.f);
        rgb[46] = new Color(0.f, 0.5937257f, 0.99999994f);
        rgb[47] = new Color(0.f, 0.6109805f, 1.f);
        rgb[48] = new Color(0.f, 0.62823534f, 1.f);
        rgb[49] = new Color(0.f, 0.64549017f, 1.f);
        rgb[50] = new Color(0.f, 0.662745f, 1.f);
        rgb[51] = new Color(0.f, 0.68000007f, 1.f);
        rgb[52] = new Color(0.f, 0.6972549f, 1.f);
        rgb[53] = new Color(0.f, 0.71450996f, 0.99999994f);
        rgb[54] = new Color(0.f, 0.7317648f, 1.f);
        rgb[55] = new Color(0.f, 0.7490196f, 1.f);
        rgb[56] = new Color(0.f, 0.76627445f, 1.f);
        rgb[57] = new Color(0.f, 0.7835295f, 1.f);
        rgb[58] = new Color(0.f, 0.80078435f, 1.f);
        rgb[59] = new Color(0.f, 0.8180392f, 1.f);
        rgb[60] = new Color(0.f, 0.83529425f, 1.f);
        rgb[61] = new Color(0.f, 0.8525491f, 1.f);
        rgb[62] = new Color(0.f, 0.8698039f, 1.f);
        rgb[63] = new Color(0.f, 0.887059f, 1.f);
        rgb[64] = new Color(0.f, 0.9043138f, 1.f);
        rgb[65] = new Color(0.f, 0.92156863f, 1.f);
        rgb[66] = new Color(0.f, 0.9388237f, 1.f);
        rgb[67] = new Color(0.f, 0.9560785f, 1.f);
        rgb[68] = new Color(0.f, 0.97333336f, 1.f);
        rgb[69] = new Color(0.f, 0.9905884f, 1.f);
        rgb[70] = new Color(0.f, 1.f, 0.99215674f);
        rgb[71] = new Color(0.f, 1.f, 0.9749019f);
        rgb[72] = new Color(0.f, 1.f, 0.95764685f);
        rgb[73] = new Color(0.f, 1.f, 0.940392f);
        rgb[74] = new Color(0.f, 1.f, 0.9231372f);
        rgb[75] = new Color(0.f, 1.f, 0.90588236f);
        rgb[76] = new Color(0.f, 1.f, 0.8886273f);
        rgb[77] = new Color(0.f, 1.f, 0.87137246f);
        rgb[78] = new Color(0.f, 1.f, 0.85411763f);
        rgb[79] = new Color(0.f, 1.f, 0.83686256f);
        rgb[80] = new Color(0.f, 1.f, 0.81960773f);
        rgb[81] = new Color(0.f, 1.f, 0.8023529f);
        rgb[82] = new Color(0.f, 1.f, 0.78509784f);
        rgb[83] = new Color(0.f, 1.f, 0.767843f);
        rgb[84] = new Color(0.f, 1.f, 0.7505882f);
        rgb[85] = new Color(0.f, 1.f, 0.73333335f);
        rgb[86] = new Color(0.f, 1.f, 0.7160783f);
        rgb[87] = new Color(0.f, 1.f, 0.69882345f);
        rgb[88] = new Color(0.f, 1.f, 0.6815686f);
        rgb[89] = new Color(0.f, 1.f, 0.66431355f);
        rgb[90] = new Color(0.f, 1.f, 0.6470587f);
        rgb[91] = new Color(0.f, 1.f, 0.6298039f);
        rgb[92] = new Color(0.f, 1.f, 0.6125488f);
        rgb[93] = new Color(0.f, 1.f, 0.595294f);
        rgb[94] = new Color(0.f, 1.f, 0.57803917f);
        rgb[95] = new Color(0.f, 1.f, 0.56078434f);
        rgb[96] = new Color(0.f, 1.f, 0.5435293f);
        rgb[97] = new Color(0.f, 1.f, 0.52627444f);
        rgb[98] = new Color(0.f, 1.f, 0.5090196f);
        rgb[99] = new Color(0.f, 1.f, 0.49176455f);
        rgb[100] = new Color(0.f, 1.f, 0.47450972f);
        rgb[101] = new Color(0.f, 1.f, 0.4572549f);
        rgb[102] = new Color(0.f, 1.f, 0.43999982f);
        rgb[103] = new Color(0.f, 1.f, 0.422745f);
        rgb[104] = new Color(0.f, 1.f, 0.40549016f);
        rgb[105] = new Color(0.f, 1.f, 0.38823533f);
        rgb[106] = new Color(0.f, 1.f, 0.37098026f);
        rgb[107] = new Color(0.f, 1.f, 0.35372543f);
        rgb[108] = new Color(0.f, 1.f, 0.3364706f);
        rgb[109] = new Color(0.f, 1.f, 0.31921554f);
        rgb[110] = new Color(0.f, 1.f, 0.3019607f);
        rgb[111] = new Color(0.f, 1.f, 0.28470588f);
        rgb[112] = new Color(0.f, 1.f, 0.2674508f);
        rgb[113] = new Color(0.f, 1.f, 0.25019598f);
        rgb[114] = new Color(0.f, 1.f, 0.23294115f);
        rgb[115] = new Color(0.f, 1.f, 0.21568632f);
        rgb[116] = new Color(0.f, 1.f, 0.19843125f);
        rgb[117] = new Color(0.f, 1.f, 0.18117642f);
        rgb[118] = new Color(0.f, 1.f, 0.1639216f);
        rgb[119] = new Color(0.f, 1.f, 0.14666677f);
        rgb[120] = new Color(0.f, 1.f, 0.1294117f);
        rgb[121] = new Color(0.f, 1.f, 0.11215687f);
        rgb[122] = new Color(0.f, 1.f, 0.09490204f);
        rgb[123] = new Color(0.f, 1.f, 0.07764697f);
        rgb[124] = new Color(0.f, 1.f, 0.06039214f);
        rgb[125] = new Color(0.f, 1.f, 0.043137312f);
        rgb[126] = new Color(0.f, 1.f, 0.025882244f);
        rgb[127] = new Color(0.f, 1.f, 0.008627415f);
        rgb[128] = new Color(0.008627653f, 1.f, 0.f);
        rgb[129] = new Color(0.025882483f, 1.f, 0.f);
        rgb[130] = new Color(0.043137312f, 1.f, 0.f);
        rgb[131] = new Color(0.06039238f, 1.f, 0.f);
        rgb[132] = new Color(0.07764721f, 1.f, 0.f);
        rgb[133] = new Color(0.09490204f, 1.f, 0.f);
        rgb[134] = new Color(0.11215711f, 1.f, 0.f);
        rgb[135] = new Color(0.12941194f, 1.f, 0.f);
        rgb[136] = new Color(0.14666677f, 1.f, 0.f);
        rgb[137] = new Color(0.1639216f, 1.f, 0.f);
        rgb[138] = new Color(0.18117666f, 1.f, 0.f);
        rgb[139] = new Color(0.19843149f, 1.f, 0.f);
        rgb[140] = new Color(0.21568632f, 1.f, 0.f);
        rgb[141] = new Color(0.23294139f, 1.f, 0.f);
        rgb[142] = new Color(0.25019622f, 1.f, 0.f);
        rgb[143] = new Color(0.26745105f, 1.f, 0.f);
        rgb[144] = new Color(0.28470612f, 1.f, 0.f);
        rgb[145] = new Color(0.30196095f, 1.f, 0.f);
        rgb[146] = new Color(0.31921577f, 1.f, 0.f);
        rgb[147] = new Color(0.3364706f, 1.f, 0.f);
        rgb[148] = new Color(0.35372567f, 1.f, 0.f);
        rgb[149] = new Color(0.3709805f, 1.f, 0.f);
        rgb[150] = new Color(0.38823533f, 1.f, 0.f);
        rgb[151] = new Color(0.4054904f, 1.f, 0.f);
        rgb[152] = new Color(0.42274523f, 1.f, 0.f);
        rgb[153] = new Color(0.44000006f, 1.f, 0.f);
        rgb[154] = new Color(0.45725513f, 1.f, 0.f);
        rgb[155] = new Color(0.47450995f, 1.f, 0.f);
        rgb[156] = new Color(0.49176478f, 1.f, 0.f);
        rgb[157] = new Color(0.5090196f, 1.f, 0.f);
        rgb[158] = new Color(0.5262747f, 1.f, 0.f);
        rgb[159] = new Color(0.5435295f, 1.f, 0.f);
        rgb[160] = new Color(0.56078434f, 1.f, 0.f);
        rgb[161] = new Color(0.5780394f, 1.f, 0.f);
        rgb[162] = new Color(0.59529424f, 1.f, 0.f);
        rgb[163] = new Color(0.61254907f, 1.f, 0.f);
        rgb[164] = new Color(0.62980413f, 1.f, 0.f);
        rgb[165] = new Color(0.64705896f, 1.f, 0.f);
        rgb[166] = new Color(0.6643138f, 1.f, 0.f);
        rgb[167] = new Color(0.6815686f, 1.f, 0.f);
        rgb[168] = new Color(0.6988237f, 1.f, 0.f);
        rgb[169] = new Color(0.7160785f, 1.f, 0.f);
        rgb[170] = new Color(0.73333335f, 1.f, 0.f);
        rgb[171] = new Color(0.7505884f, 1.f, 0.f);
        rgb[172] = new Color(0.76784325f, 1.f, 0.f);
        rgb[173] = new Color(0.7850981f, 1.f, 0.f);
        rgb[174] = new Color(0.80235314f, 1.f, 0.f);
        rgb[175] = new Color(0.819608f, 1.f, 0.f);
        rgb[176] = new Color(0.8368628f, 1.f, 0.f);
        rgb[177] = new Color(0.85411763f, 1.f, 0.f);
        rgb[178] = new Color(0.8713727f, 1.f, 0.f);
        rgb[179] = new Color(0.8886275f, 1.f, 0.f);
        rgb[180] = new Color(0.90588236f, 1.f, 0.f);
        rgb[181] = new Color(0.9231374f, 1.f, 0.f);
        rgb[182] = new Color(0.94039226f, 1.f, 0.f);
        rgb[183] = new Color(0.9576471f, 1.f, 0.f);
        rgb[184] = new Color(0.97490215f, 1.f, 0.f);
        rgb[185] = new Color(0.992157f, 1.f, 0.f);
        rgb[186] = new Color(1.f, 0.9905882f, 0.f);
        rgb[187] = new Color(1.f, 0.97333336f, 0.f);
        rgb[188] = new Color(1.f, 0.95607805f, 0.f);
        rgb[189] = new Color(1.f, 0.9388232f, 0.f);
        rgb[190] = new Color(1.f, 0.9215684f, 0.f);
        rgb[191] = new Color(1.f, 0.90431356f, 0.f);
        rgb[192] = new Color(1.f, 0.88705873f, 0.f);
        rgb[193] = new Color(1.f, 0.8698039f, 0.f);
        rgb[194] = new Color(1.f, 0.8525486f, 0.f);
        rgb[195] = new Color(1.f, 0.83529377f, 0.f);
        rgb[196] = new Color(1.f, 0.81803894f, 0.f);
        rgb[197] = new Color(1.f, 0.8007841f, 0.f);
        rgb[198] = new Color(1.f, 0.7835293f, 0.f);
        rgb[199] = new Color(1.f, 0.76627445f, 0.f);
        rgb[200] = new Color(1.f, 0.7490196f, 0.f);
        rgb[201] = new Color(1.f, 0.7317643f, 0.f);
        rgb[202] = new Color(1.f, 0.7145095f, 0.f);
        rgb[203] = new Color(1.f, 0.69725466f, 0.f);
        rgb[204] = new Color(1.f, 0.6799998f, 0.f);
        rgb[205] = new Color(1.f, 0.662745f, 0.f);
        rgb[206] = new Color(1.f, 0.64549017f, 0.f);
        rgb[207] = new Color(1.f, 0.62823486f, 0.f);
        rgb[208] = new Color(1.f, 0.61098003f, 0.f);
        rgb[209] = new Color(1.f, 0.5937252f, 0.f);
        rgb[210] = new Color(1.f, 0.5764704f, 0.f);
        rgb[211] = new Color(1.f, 0.55921555f, 0.f);
        rgb[212] = new Color(1.f, 0.5419607f, 0.f);
        rgb[213] = new Color(1.f, 0.5247059f, 0.f);
        rgb[214] = new Color(1.f, 0.5074506f, 0.f);
        rgb[215] = new Color(1.f, 0.49019575f, 0.f);
        rgb[216] = new Color(1.f, 0.47294092f, 0.f);
        rgb[217] = new Color(1.f, 0.4556861f, 0.f);
        rgb[218] = new Color(1.f, 0.43843126f, 0.f);
        rgb[219] = new Color(1.f, 0.42117643f, 0.f);
        rgb[220] = new Color(1.f, 0.4039216f, 0.f);
        rgb[221] = new Color(1.f, 0.3866663f, 0.f);
        rgb[222] = new Color(1.f, 0.36941147f, 0.f);
        rgb[223] = new Color(1.f, 0.35215664f, 0.f);
        rgb[224] = new Color(1.f, 0.3349018f, 0.f);
        rgb[225] = new Color(1.f, 0.31764698f, 0.f);
        rgb[226] = new Color(1.f, 0.30039215f, 0.f);
        rgb[227] = new Color(1.f, 0.28313684f, 0.f);
        rgb[228] = new Color(1.f, 0.26588202f, 0.f);
        rgb[229] = new Color(1.f, 0.24862719f, 0.f);
        rgb[230] = new Color(1.f, 0.23137236f, 0.f);
        rgb[231] = new Color(1.f, 0.21411753f, 0.f);
        rgb[232] = new Color(1.f, 0.19686222f, 0.f);
        rgb[233] = new Color(1.f, 0.17960739f, 0.f);
        rgb[234] = new Color(1.f, 0.16235256f, 0.f);
        rgb[235] = new Color(1.f, 0.14509773f, 0.f);
        rgb[236] = new Color(1.f, 0.1278429f, 0.f);
        rgb[237] = new Color(1.f, 0.110588074f, 0.f);
        rgb[238] = new Color(1.f, 0.093333244f, 0.f);
        rgb[239] = new Color(1.f, 0.07607794f, 0.f);
        rgb[240] = new Color(1.f, 0.05882311f, 0.f);
        rgb[241] = new Color(1.f, 0.04156828f, 0.f);
        rgb[242] = new Color(1.f, 0.02431345f, 0.f);
        rgb[243] = new Color(1.f, 0.0070586205f, 0.f);
        rgb[244] = new Color(0.9898038f, 0.f, 0.f);
        rgb[245] = new Color(0.97254896f, 0.f, 0.f);
        rgb[246] = new Color(0.95529366f, 0.f, 0.f);
        rgb[247] = new Color(0.9380388f, 0.f, 0.f);
        rgb[248] = new Color(0.920784f, 0.f, 0.f);
        rgb[249] = new Color(0.90352917f, 0.f, 0.f);
        rgb[250] = new Color(0.88627434f, 0.f, 0.f);
        rgb[251] = new Color(0.8690195f, 0.f, 0.f);
        rgb[252] = new Color(0.8517642f, 0.f, 0.f);
        rgb[253] = new Color(0.8345094f, 0.f, 0.f);
        rgb[254] = new Color(0.81725454f, 0.f, 0.f);
        rgb[255] = new Color(1.f, 1.f, 1.f);
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
            PseudoRainbow pseudoRainbow = new PseudoRainbow();
            ImageIO.write(pseudoRainbow.getBufferedImage(), "png", new File("/home/aurea/results/scale.png"));
        } catch (IOException ex) {
            Logger.getLogger(PseudoRainbow.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
}
