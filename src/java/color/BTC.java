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
public class BTC implements ColorScale {

    @Override
    public Color[] getColorScale() {
        Color[] rgb;
        rgb = new Color[256];

        rgb[  0] = new Color(0, 0, 0);
        rgb[  1] = new Color(0, 0, 40);
        rgb[  2] = new Color(0, 4, 56);
        rgb[  3] = new Color(0, 9, 61);
        rgb[  4] = new Color(0, 12, 64);
        rgb[  5] = new Color(0, 14, 66);
        rgb[  6] = new Color(0, 17, 69);
        rgb[  7] = new Color(0, 20, 73);
        rgb[  8] = new Color(0, 22, 74);
        rgb[  9] = new Color(0, 25, 78);
        rgb[ 10] = new Color(0, 27, 79);
        rgb[ 11] = new Color(0, 30, 83);
        rgb[ 12] = new Color(0, 31, 85);
        rgb[ 13] = new Color(0, 33, 86);
        rgb[ 14] = new Color(0, 36, 90);
        rgb[ 15] = new Color(0, 38, 91);
        rgb[ 16] = new Color(0, 39, 93);
        rgb[ 17] = new Color(0, 41, 95);
        rgb[ 18] = new Color(0, 43, 96);
        rgb[ 19] = new Color(0, 46, 100);
        rgb[ 20] = new Color(0, 47, 102);
        rgb[ 21] = new Color(0, 49, 103);
        rgb[ 22] = new Color(0, 51, 105);
        rgb[ 23] = new Color(0, 52, 107);
        rgb[ 24] = new Color(0, 54, 108);
        rgb[ 25] = new Color(0, 55, 110);
        rgb[ 26] = new Color(0, 57, 112);
        rgb[ 27] = new Color(0, 57, 112);
        rgb[ 28] = new Color(0, 58, 113);
        rgb[ 29] = new Color(0, 60, 115);
        rgb[ 30] = new Color(0, 62, 117);
        rgb[ 31] = new Color(0, 63, 119);
        rgb[ 32] = new Color(0, 65, 120);
        rgb[ 33] = new Color(0, 66, 122);
        rgb[ 34] = new Color(0, 68, 124);
        rgb[ 35] = new Color(0, 70, 125);
        rgb[ 36] = new Color(0, 71, 127);
        rgb[ 37] = new Color(0, 73, 129);
        rgb[ 38] = new Color(0, 73, 129);
        rgb[ 39] = new Color(0, 74, 130);
        rgb[ 40] = new Color(0, 76, 132);
        rgb[ 41] = new Color(0, 78, 134);
        rgb[ 42] = new Color(0, 79, 136);
        rgb[ 43] = new Color(0, 81, 137);
        rgb[ 44] = new Color(0, 82, 139);
        rgb[ 45] = new Color(0, 84, 141);
        rgb[ 46] = new Color(0, 86, 142);
        rgb[ 47] = new Color(0, 87, 144);
        rgb[ 48] = new Color(0, 89, 146);
        rgb[ 49] = new Color(0, 90, 147);
        rgb[ 50] = new Color(0, 92, 149);
        rgb[ 51] = new Color(0, 94, 151);
        rgb[ 52] = new Color(0, 94, 151);
        rgb[ 53] = new Color(0, 95, 153);
        rgb[ 54] = new Color(0, 97, 154);
        rgb[ 55] = new Color(0, 98, 156);
        rgb[ 56] = new Color(0, 100, 158);
        rgb[ 57] = new Color(0, 102, 159);
        rgb[ 58] = new Color(0, 103, 161);
        rgb[ 59] = new Color(0, 105, 163);
        rgb[ 60] = new Color(0, 106, 164);
        rgb[ 61] = new Color(0, 108, 166);
        rgb[ 62] = new Color(0, 109, 168);
        rgb[ 63] = new Color(0, 111, 170);
        rgb[ 64] = new Color(0, 113, 171);
        rgb[ 65] = new Color(0, 114, 173);
        rgb[ 66] = new Color(0, 116, 175);
        rgb[ 67] = new Color(0, 117, 176);
        rgb[ 68] = new Color(0, 119, 178);
        rgb[ 69] = new Color(0, 121, 180);
        rgb[ 70] = new Color(0, 121, 180);
        rgb[ 71] = new Color(0, 122, 181);
        rgb[ 72] = new Color(0, 124, 183);
        rgb[ 73] = new Color(0, 125, 185);
        rgb[ 74] = new Color(0, 127, 187);
        rgb[ 75] = new Color(0, 129, 188);
        rgb[ 76] = new Color(0, 130, 190);
        rgb[ 77] = new Color(0, 132, 192);
        rgb[ 78] = new Color(0, 133, 193);
        rgb[ 79] = new Color(0, 135, 195);
        rgb[ 80] = new Color(0, 137, 197);
        rgb[ 81] = new Color(0, 138, 198);
        rgb[ 82] = new Color(0, 140, 200);
        rgb[ 83] = new Color(0, 141, 202);
        rgb[ 84] = new Color(0, 143, 204);
        rgb[ 85] = new Color(0, 143, 204);
        rgb[ 86] = new Color(0, 145, 205);
        rgb[ 87] = new Color(0, 146, 207);
        rgb[ 88] = new Color(0, 148, 209);
        rgb[ 89] = new Color(0, 149, 210);
        rgb[ 90] = new Color(0, 151, 212);
        rgb[ 91] = new Color(0, 153, 214);
        rgb[ 92] = new Color(0, 154, 215);
        rgb[ 93] = new Color(0, 156, 217);
        rgb[ 94] = new Color(0, 157, 219);
        rgb[ 95] = new Color(0, 159, 221);
        rgb[ 96] = new Color(0, 160, 222);
        rgb[ 97] = new Color(0, 160, 222);
        rgb[ 98] = new Color(0, 162, 224);
        rgb[ 99] = new Color(0, 164, 226);
        rgb[100] = new Color(0, 165, 227);
        rgb[101] = new Color(0, 167, 229);
        rgb[102] = new Color(0, 168, 231);
        rgb[103] = new Color(0, 170, 232);
        rgb[104] = new Color(0, 172, 234);
        rgb[105] = new Color(0, 173, 236);
        rgb[106] = new Color(0, 175, 238);
        rgb[107] = new Color(0, 175, 238);
        rgb[108] = new Color(0, 176, 239);
        rgb[109] = new Color(0, 178, 241);
        rgb[110] = new Color(0, 180, 243);
        rgb[111] = new Color(0, 181, 244);
        rgb[112] = new Color(0, 183, 246);
        rgb[113] = new Color(2, 184, 248);
        rgb[114] = new Color(4, 186, 249);
        rgb[115] = new Color(4, 186, 249);
        rgb[116] = new Color(4, 186, 249);
        rgb[117] = new Color(6, 188, 251);
        rgb[118] = new Color(6, 188, 251);
        rgb[119] = new Color(9, 189, 253);
        rgb[120] = new Color(9, 189, 253);
        rgb[121] = new Color(11, 191, 255);
        rgb[122] = new Color(11, 191, 255);
        rgb[123] = new Color(13, 192, 255);
        rgb[124] = new Color(13, 192, 255);
        rgb[125] = new Color(13, 192, 255);
        rgb[126] = new Color(16, 194, 255);
        rgb[127] = new Color(18, 196, 255);
        rgb[128] = new Color(20, 197, 255);
        rgb[129] = new Color(20, 197, 255);
        rgb[130] = new Color(23, 199, 255);
        rgb[131] = new Color(25, 200, 255);
        rgb[132] = new Color(27, 202, 255);
        rgb[133] = new Color(30, 204, 255);
        rgb[134] = new Color(32, 205, 255);
        rgb[135] = new Color(34, 207, 255);
        rgb[136] = new Color(37, 208, 255);
        rgb[137] = new Color(37, 208, 255);
        rgb[138] = new Color(39, 210, 255);
        rgb[139] = new Color(41, 211, 255);
        rgb[140] = new Color(44, 213, 255);
        rgb[141] = new Color(46, 215, 255);
        rgb[142] = new Color(48, 216, 255);
        rgb[143] = new Color(51, 218, 255);
        rgb[144] = new Color(53, 219, 255);
        rgb[145] = new Color(53, 219, 255);
        rgb[146] = new Color(55, 221, 255);
        rgb[147] = new Color(57, 223, 255);
        rgb[148] = new Color(60, 224, 255);
        rgb[149] = new Color(62, 226, 255);
        rgb[150] = new Color(64, 227, 255);
        rgb[151] = new Color(67, 229, 255);
        rgb[152] = new Color(67, 229, 255);
        rgb[153] = new Color(69, 231, 255);
        rgb[154] = new Color(71, 232, 255);
        rgb[155] = new Color(74, 234, 255);
        rgb[156] = new Color(76, 235, 255);
        rgb[157] = new Color(78, 237, 255);
        rgb[158] = new Color(81, 239, 255);
        rgb[159] = new Color(81, 239, 255);
        rgb[160] = new Color(83, 240, 255);
        rgb[161] = new Color(85, 242, 255);
        rgb[162] = new Color(88, 243, 255);
        rgb[163] = new Color(90, 245, 255);
        rgb[164] = new Color(92, 247, 255);
        rgb[165] = new Color(95, 248, 255);
        rgb[166] = new Color(95, 248, 255);
        rgb[167] = new Color(97, 250, 255);
        rgb[168] = new Color(99, 251, 255);
        rgb[169] = new Color(102, 253, 255);
        rgb[170] = new Color(104, 255, 255);
        rgb[171] = new Color(106, 255, 255);
        rgb[172] = new Color(106, 255, 255);
        rgb[173] = new Color(108, 255, 255);
        rgb[174] = new Color(111, 255, 255);
        rgb[175] = new Color(113, 255, 255);
        rgb[176] = new Color(115, 255, 255);
        rgb[177] = new Color(115, 255, 255);
        rgb[178] = new Color(118, 255, 255);
        rgb[179] = new Color(120, 255, 255);
        rgb[180] = new Color(122, 255, 255);
        rgb[181] = new Color(122, 255, 255);
        rgb[182] = new Color(125, 255, 255);
        rgb[183] = new Color(127, 255, 255);
        rgb[184] = new Color(129, 255, 255);
        rgb[185] = new Color(129, 255, 255);
        rgb[186] = new Color(132, 255, 255);
        rgb[187] = new Color(134, 255, 255);
        rgb[188] = new Color(136, 255, 255);
        rgb[189] = new Color(136, 255, 255);
        rgb[190] = new Color(139, 255, 255);
        rgb[191] = new Color(141, 255, 255);
        rgb[192] = new Color(143, 255, 255);
        rgb[193] = new Color(143, 255, 255);
        rgb[194] = new Color(146, 255, 255);
        rgb[195] = new Color(148, 255, 255);
        rgb[196] = new Color(150, 255, 255);
        rgb[197] = new Color(150, 255, 255);
        rgb[198] = new Color(153, 255, 255);
        rgb[199] = new Color(155, 255, 255);
        rgb[200] = new Color(155, 255, 255);
        rgb[201] = new Color(157, 255, 255);
        rgb[202] = new Color(159, 255, 255);
        rgb[203] = new Color(159, 255, 255);
        rgb[204] = new Color(162, 255, 255);
        rgb[205] = new Color(164, 255, 255);
        rgb[206] = new Color(164, 255, 255);
        rgb[207] = new Color(166, 255, 255);
        rgb[208] = new Color(169, 255, 255);
        rgb[209] = new Color(171, 255, 255);
        rgb[210] = new Color(171, 255, 255);
        rgb[211] = new Color(173, 255, 255);
        rgb[212] = new Color(176, 255, 255);
        rgb[213] = new Color(176, 255, 255);
        rgb[214] = new Color(178, 255, 255);
        rgb[215] = new Color(180, 255, 255);
        rgb[216] = new Color(180, 255, 255);
        rgb[217] = new Color(183, 255, 255);
        rgb[218] = new Color(185, 255, 255);
        rgb[219] = new Color(185, 255, 255);
        rgb[220] = new Color(187, 255, 255);
        rgb[221] = new Color(190, 255, 255);
        rgb[222] = new Color(190, 255, 255);
        rgb[223] = new Color(192, 255, 255);
        rgb[224] = new Color(194, 255, 255);
        rgb[225] = new Color(197, 255, 255);
        rgb[226] = new Color(197, 255, 255);
        rgb[227] = new Color(199, 255, 255);
        rgb[228] = new Color(201, 255, 255);
        rgb[229] = new Color(204, 255, 255);
        rgb[230] = new Color(204, 255, 255);
        rgb[231] = new Color(206, 255, 255);
        rgb[232] = new Color(208, 255, 255);
        rgb[233] = new Color(210, 255, 255);
        rgb[234] = new Color(210, 255, 255);
        rgb[235] = new Color(213, 255, 255);
        rgb[236] = new Color(215, 255, 255);
        rgb[237] = new Color(217, 255, 255);
        rgb[238] = new Color(217, 255, 255);
        rgb[239] = new Color(220, 255, 255);
        rgb[240] = new Color(222, 255, 255);
        rgb[241] = new Color(224, 255, 255);
        rgb[242] = new Color(227, 255, 255);
        rgb[243] = new Color(229, 255, 255);
        rgb[244] = new Color(229, 255, 255);
        rgb[245] = new Color(231, 255, 255);
        rgb[246] = new Color(234, 255, 255);
        rgb[247] = new Color(236, 255, 255);
        rgb[248] = new Color(238, 255, 255);
        rgb[249] = new Color(241, 255, 255);
        rgb[250] = new Color(243, 255, 255);
        rgb[251] = new Color(243, 255, 255);
        rgb[252] = new Color(245, 255, 255);
        rgb[253] = new Color(248, 255, 255);
        rgb[254] = new Color(250, 255, 255);
        rgb[255] = new Color(255, 255, 255);
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
            BTC btc = new BTC();
            ImageIO.write(btc.getBufferedImage(), "png", new File("/home/aurea/btc.png"));
        } catch (IOException ex) {
            Logger.getLogger(PseudoRainbow.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
}
