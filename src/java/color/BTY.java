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
public class BTY implements ColorScale {

    @Override
    public Color[] getColorScale() {
        Color[] rgb;
        rgb = new Color[256];
        rgb[  0] = new Color(7, 7, 254);
        rgb[  1] = new Color(23, 23, 252);
        rgb[  2] = new Color(30, 30, 250);
        rgb[  3] = new Color(36, 36, 248);
        rgb[  4] = new Color(40, 40, 247);
        rgb[  5] = new Color(44, 44, 245);
        rgb[  6] = new Color(47, 47, 243);
        rgb[  7] = new Color(50, 50, 242);
        rgb[  8] = new Color(52, 52, 240);
        rgb[  9] = new Color(55, 55, 239);
        rgb[ 10] = new Color(57, 57, 238);
        rgb[ 11] = new Color(59, 59, 236);
        rgb[ 12] = new Color(61, 61, 235);
        rgb[ 13] = new Color(63, 63, 234);
        rgb[ 14] = new Color(65, 65, 233);
        rgb[ 15] = new Color(66, 66, 231);
        rgb[ 16] = new Color(68, 68, 230);
        rgb[ 17] = new Color(69, 69, 229);
        rgb[ 18] = new Color(71, 71, 228);
        rgb[ 19] = new Color(72, 72, 227);
        rgb[ 20] = new Color(74, 74, 226);
        rgb[ 21] = new Color(75, 75, 225);
        rgb[ 22] = new Color(76, 76, 225);
        rgb[ 23] = new Color(78, 78, 224);
        rgb[ 24] = new Color(79, 79, 223);
        rgb[ 25] = new Color(80, 80, 222);
        rgb[ 26] = new Color(81, 81, 221);
        rgb[ 27] = new Color(82, 82, 221);
        rgb[ 28] = new Color(84, 84, 220);
        rgb[ 29] = new Color(85, 85, 219);
        rgb[ 30] = new Color(86, 86, 218);
        rgb[ 31] = new Color(87, 87, 218);
        rgb[ 32] = new Color(88, 88, 217);
        rgb[ 33] = new Color(89, 89, 216);
        rgb[ 34] = new Color(90, 90, 216);
        rgb[ 35] = new Color(91, 91, 215);
        rgb[ 36] = new Color(92, 92, 214);
        rgb[ 37] = new Color(93, 93, 214);
        rgb[ 38] = new Color(94, 94, 213);
        rgb[ 39] = new Color(95, 95, 213);
        rgb[ 40] = new Color(96, 96, 212);
        rgb[ 41] = new Color(97, 97, 212);
        rgb[ 42] = new Color(98, 98, 211);
        rgb[ 43] = new Color(98, 98, 210);
        rgb[ 44] = new Color(99, 99, 210);
        rgb[ 45] = new Color(100, 100, 209);
        rgb[ 46] = new Color(101, 101, 209);
        rgb[ 47] = new Color(102, 102, 208);
        rgb[ 48] = new Color(103, 103, 208);
        rgb[ 49] = new Color(104, 104, 208);
        rgb[ 50] = new Color(105, 105, 207);
        rgb[ 51] = new Color(105, 105, 207);
        rgb[ 52] = new Color(106, 106, 206);
        rgb[ 53] = new Color(107, 107, 206);
        rgb[ 54] = new Color(108, 108, 205);
        rgb[ 55] = new Color(109, 109, 205);
        rgb[ 56] = new Color(110, 110, 204);
        rgb[ 57] = new Color(110, 110, 204);
        rgb[ 58] = new Color(111, 111, 204);
        rgb[ 59] = new Color(112, 112, 203);
        rgb[ 60] = new Color(113, 113, 203);
        rgb[ 61] = new Color(114, 114, 202);
        rgb[ 62] = new Color(114, 114, 202);
        rgb[ 63] = new Color(115, 115, 202);
        rgb[ 64] = new Color(116, 116, 201);
        rgb[ 65] = new Color(117, 117, 201);
        rgb[ 66] = new Color(118, 118, 200);
        rgb[ 67] = new Color(118, 118, 200);
        rgb[ 68] = new Color(119, 119, 200);
        rgb[ 69] = new Color(120, 120, 199);
        rgb[ 70] = new Color(121, 121, 199);
        rgb[ 71] = new Color(121, 121, 199);
        rgb[ 72] = new Color(122, 122, 198);
        rgb[ 73] = new Color(123, 123, 198);
        rgb[ 74] = new Color(124, 124, 198);
        rgb[ 75] = new Color(124, 124, 197);
        rgb[ 76] = new Color(125, 125, 197);
        rgb[ 77] = new Color(126, 126, 197);
        rgb[ 78] = new Color(127, 127, 196);
        rgb[ 79] = new Color(128, 128, 196);
        rgb[ 80] = new Color(128, 128, 195);
        rgb[ 81] = new Color(129, 129, 195);
        rgb[ 82] = new Color(130, 130, 195);
        rgb[ 83] = new Color(130, 130, 194);
        rgb[ 84] = new Color(131, 131, 194);
        rgb[ 85] = new Color(132, 132, 194);
        rgb[ 86] = new Color(133, 133, 193);
        rgb[ 87] = new Color(133, 133, 193);
        rgb[ 88] = new Color(134, 134, 193);
        rgb[ 89] = new Color(135, 135, 192);
        rgb[ 90] = new Color(136, 136, 192);
        rgb[ 91] = new Color(136, 136, 192);
        rgb[ 92] = new Color(137, 137, 191);
        rgb[ 93] = new Color(138, 138, 191);
        rgb[ 94] = new Color(139, 139, 191);
        rgb[ 95] = new Color(139, 139, 190);
        rgb[ 96] = new Color(140, 140, 190);
        rgb[ 97] = new Color(141, 141, 190);
        rgb[ 98] = new Color(142, 142, 189);
        rgb[ 99] = new Color(142, 142, 189);
        rgb[100] = new Color(143, 143, 189);
        rgb[101] = new Color(144, 144, 188);
        rgb[102] = new Color(144, 144, 188);
        rgb[103] = new Color(145, 145, 188);
        rgb[104] = new Color(146, 146, 187);
        rgb[105] = new Color(147, 147, 187);
        rgb[106] = new Color(147, 147, 187);
        rgb[107] = new Color(148, 148, 186);
        rgb[108] = new Color(149, 149, 186);
        rgb[109] = new Color(149, 149, 186);
        rgb[110] = new Color(150, 150, 185);
        rgb[111] = new Color(151, 151, 185);
        rgb[112] = new Color(152, 152, 185);
        rgb[113] = new Color(152, 152, 184);
        rgb[114] = new Color(153, 153, 184);
        rgb[115] = new Color(154, 154, 184);
        rgb[116] = new Color(154, 154, 183);
        rgb[117] = new Color(155, 155, 183);
        rgb[118] = new Color(156, 156, 182);
        rgb[119] = new Color(157, 157, 182);
        rgb[120] = new Color(157, 157, 182);
        rgb[121] = new Color(158, 158, 181);
        rgb[122] = new Color(159, 159, 181);
        rgb[123] = new Color(159, 159, 181);
        rgb[124] = new Color(160, 160, 180);
        rgb[125] = new Color(161, 161, 180);
        rgb[126] = new Color(162, 162, 180);
        rgb[127] = new Color(162, 162, 179);
        rgb[128] = new Color(163, 163, 179);
        rgb[129] = new Color(164, 164, 178);
        rgb[130] = new Color(164, 164, 178);
        rgb[131] = new Color(165, 165, 178);
        rgb[132] = new Color(166, 166, 177);
        rgb[133] = new Color(167, 167, 177);
        rgb[134] = new Color(167, 167, 176);
        rgb[135] = new Color(168, 168, 176);
        rgb[136] = new Color(169, 169, 176);
        rgb[137] = new Color(169, 169, 175);
        rgb[138] = new Color(170, 170, 175);
        rgb[139] = new Color(171, 171, 174);
        rgb[140] = new Color(172, 172, 174);
        rgb[141] = new Color(172, 172, 173);
        rgb[142] = new Color(173, 173, 173);
        rgb[143] = new Color(174, 174, 173);
        rgb[144] = new Color(174, 174, 172);
        rgb[145] = new Color(175, 175, 172);
        rgb[146] = new Color(176, 176, 171);
        rgb[147] = new Color(177, 177, 171);
        rgb[148] = new Color(177, 177, 170);
        rgb[149] = new Color(178, 178, 170);
        rgb[150] = new Color(179, 179, 169);
        rgb[151] = new Color(179, 179, 169);
        rgb[152] = new Color(180, 180, 168);
        rgb[153] = new Color(181, 181, 168);
        rgb[154] = new Color(181, 181, 167);
        rgb[155] = new Color(182, 182, 167);
        rgb[156] = new Color(183, 183, 166);
        rgb[157] = new Color(184, 184, 166);
        rgb[158] = new Color(184, 184, 165);
        rgb[159] = new Color(185, 185, 165);
        rgb[160] = new Color(186, 186, 164);
        rgb[161] = new Color(186, 186, 164);
        rgb[162] = new Color(187, 187, 163);
        rgb[163] = new Color(188, 188, 163);
        rgb[164] = new Color(189, 189, 162);
        rgb[165] = new Color(189, 189, 162);
        rgb[166] = new Color(190, 190, 161);
        rgb[167] = new Color(191, 191, 161);
        rgb[168] = new Color(191, 191, 160);
        rgb[169] = new Color(192, 192, 159);
        rgb[170] = new Color(193, 193, 159);
        rgb[171] = new Color(194, 194, 158);
        rgb[172] = new Color(194, 194, 158);
        rgb[173] = new Color(195, 195, 157);
        rgb[174] = new Color(196, 196, 157);
        rgb[175] = new Color(196, 196, 156);
        rgb[176] = new Color(197, 197, 155);
        rgb[177] = new Color(198, 198, 155);
        rgb[178] = new Color(199, 199, 154);
        rgb[179] = new Color(199, 199, 153);
        rgb[180] = new Color(200, 200, 153);
        rgb[181] = new Color(201, 201, 152);
        rgb[182] = new Color(201, 201, 151);
        rgb[183] = new Color(202, 202, 151);
        rgb[184] = new Color(203, 203, 150);
        rgb[185] = new Color(204, 204, 149);
        rgb[186] = new Color(204, 204, 149);
        rgb[187] = new Color(205, 205, 148);
        rgb[188] = new Color(206, 206, 147);
        rgb[189] = new Color(206, 206, 146);
        rgb[190] = new Color(207, 207, 146);
        rgb[191] = new Color(208, 208, 145);
        rgb[192] = new Color(209, 209, 144);
        rgb[193] = new Color(209, 209, 143);
        rgb[194] = new Color(210, 210, 143);
        rgb[195] = new Color(211, 211, 142);
        rgb[196] = new Color(211, 211, 141);
        rgb[197] = new Color(212, 212, 140);
        rgb[198] = new Color(213, 213, 139);
        rgb[199] = new Color(214, 214, 138);
        rgb[200] = new Color(214, 214, 138);
        rgb[201] = new Color(215, 215, 137);
        rgb[202] = new Color(216, 216, 136);
        rgb[203] = new Color(216, 216, 135);
        rgb[204] = new Color(217, 217, 134);
        rgb[205] = new Color(218, 218, 133);
        rgb[206] = new Color(219, 219, 132);
        rgb[207] = new Color(219, 219, 131);
        rgb[208] = new Color(220, 220, 130);
        rgb[209] = new Color(221, 221, 129);
        rgb[210] = new Color(221, 221, 128);
        rgb[211] = new Color(222, 222, 127);
        rgb[212] = new Color(223, 223, 126);
        rgb[213] = new Color(224, 224, 125);
        rgb[214] = new Color(224, 224, 124);
        rgb[215] = new Color(225, 225, 123);
        rgb[216] = new Color(226, 226, 122);
        rgb[217] = new Color(226, 226, 121);
        rgb[218] = new Color(227, 227, 119);
        rgb[219] = new Color(228, 228, 118);
        rgb[220] = new Color(229, 229, 117);
        rgb[221] = new Color(229, 229, 116);
        rgb[222] = new Color(230, 230, 114);
        rgb[223] = new Color(231, 231, 113);
        rgb[224] = new Color(232, 232, 112);
        rgb[225] = new Color(232, 232, 110);
        rgb[226] = new Color(233, 233, 109);
        rgb[227] = new Color(234, 234, 107);
        rgb[228] = new Color(234, 234, 106);
        rgb[229] = new Color(235, 235, 104);
        rgb[230] = new Color(236, 236, 103);
        rgb[231] = new Color(237, 237, 101);
        rgb[232] = new Color(237, 237, 100);
        rgb[233] = new Color(238, 238, 98);
        rgb[234] = new Color(239, 239, 96);
        rgb[235] = new Color(239, 239, 94);
        rgb[236] = new Color(240, 240, 92);
        rgb[237] = new Color(241, 241, 91);
        rgb[238] = new Color(242, 242, 89);
        rgb[239] = new Color(242, 242, 86);
        rgb[240] = new Color(243, 243, 84);
        rgb[241] = new Color(244, 244, 82);
        rgb[242] = new Color(245, 245, 80);
        rgb[243] = new Color(245, 245, 77);
        rgb[244] = new Color(246, 246, 74);
        rgb[245] = new Color(247, 247, 72);
        rgb[246] = new Color(247, 247, 69);
        rgb[247] = new Color(248, 248, 65);
        rgb[248] = new Color(249, 249, 62);
        rgb[249] = new Color(250, 250, 58);
        rgb[250] = new Color(250, 250, 54);
        rgb[251] = new Color(251, 251, 49);
        rgb[252] = new Color(252, 252, 44);
        rgb[253] = new Color(253, 253, 37);
        rgb[254] = new Color(253, 253, 28);
        //rgb[255] = new Color( 254/255,  254/255,   13/255) ;
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
            BTY bty = new BTY();
            ImageIO.write(bty.getBufferedImage(), "png", new File("/home/aurea/results/scale_bty.png"));
        } catch (IOException ex) {
            Logger.getLogger(PseudoRainbow.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
}
