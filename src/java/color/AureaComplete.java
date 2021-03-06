/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package color;

import java.awt.Color;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.util.Arrays;
import java.util.Collections;
import java.util.Comparator;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.imageio.ImageIO;
import utils.ColorScale;

/**
 *
 * @author aurea
 */
public class AureaComplete implements ColorScale {

    @Override
    public Color[] getColorScale() {
        Color[] rgb;
        rgb = new Color[758];
        rgb[0] = new Color(92, 138, 168);
        rgb[1] = new Color(240, 247, 255);
        rgb[2] = new Color(209, 26, 66);
        rgb[3] = new Color(240, 222, 204);
        rgb[4] = new Color(230, 43, 79);
        rgb[5] = new Color(255, 191, 0);
        rgb[6] = new Color(255, 125, 0);
        rgb[7] = new Color(255, 3, 61);
        rgb[8] = new Color(153, 102, 204);
        rgb[9] = new Color(242, 242, 245);
        rgb[10] = new Color(204, 148, 117);
        rgb[11] = new Color(145, 92, 130);
        rgb[12] = new Color(250, 235, 214);
        rgb[13] = new Color(0, 0, 255);
        rgb[14] = new Color(0, 128, 0);
        rgb[15] = new Color(140, 181, 0);
        rgb[16] = new Color(250, 207, 176);
        rgb[17] = new Color(0, 255, 255);
        rgb[18] = new Color(128, 255, 212);
        rgb[19] = new Color(74, 84, 33);
        rgb[20] = new Color(59, 69, 74);
        rgb[21] = new Color(232, 214, 107);
        rgb[22] = new Color(179, 191, 181);
        rgb[23] = new Color(135, 168, 107);
        rgb[24] = new Color(255, 153, 102);
        rgb[25] = new Color(110, 54, 26);
        rgb[26] = new Color(252, 237, 0);
        rgb[27] = new Color(110, 128, 128);
        rgb[28] = new Color(255, 33, 82);
        rgb[29] = new Color(0, 128, 255);
        rgb[30] = new Color(240, 255, 255);
        rgb[31] = new Color(138, 207, 240);
        rgb[32] = new Color(161, 201, 242);
        rgb[33] = new Color(245, 194, 194);
        rgb[34] = new Color(33, 171, 204);
        rgb[35] = new Color(250, 232, 181);
        rgb[36] = new Color(255, 224, 54);
        rgb[37] = new Color(133, 133, 130);
        rgb[38] = new Color(153, 120, 122);
        rgb[39] = new Color(189, 212, 230);
        rgb[40] = new Color(158, 130, 112);
        rgb[41] = new Color(245, 245, 219);
        rgb[42] = new Color(255, 227, 196);
        rgb[43] = new Color(61, 43, 31);
        rgb[44] = new Color(255, 112, 94);
        rgb[45] = new Color(0, 0, 0);
        rgb[46] = new Color(255, 235, 204);
        rgb[47] = new Color(48, 140, 232);
        rgb[48] = new Color(171, 230, 237);
        rgb[49] = new Color(250, 240, 191);
        rgb[50] = new Color(0, 0, 255);
        rgb[51] = new Color(0, 128, 176);
        rgb[52] = new Color(0, 135, 189);
        rgb[53] = new Color(51, 51, 153);
        rgb[54] = new Color(3, 71, 255);
        rgb[55] = new Color(163, 163, 209);
        rgb[56] = new Color(102, 153, 204);
        rgb[57] = new Color(0, 222, 222);
        rgb[58] = new Color(138, 43, 227);
        rgb[59] = new Color(222, 92, 130);
        rgb[60] = new Color(120, 69, 59);
        rgb[61] = new Color(0, 148, 181);
        rgb[62] = new Color(204, 0, 0);
        rgb[63] = new Color(0, 112, 255);
        rgb[64] = new Color(181, 166, 66);
        rgb[65] = new Color(204, 64, 84);
        rgb[66] = new Color(28, 171, 214);
        rgb[67] = new Color(102, 255, 0);
        rgb[68] = new Color(191, 148, 227);
        rgb[69] = new Color(194, 33, 71);
        rgb[70] = new Color(255, 0, 128);
        rgb[71] = new Color(8, 232, 222);
        rgb[72] = new Color(209, 158, 232);
        rgb[73] = new Color(245, 186, 255);
        rgb[74] = new Color(255, 84, 163);
        rgb[75] = new Color(250, 97, 128);
        rgb[76] = new Color(0, 66, 38);
        rgb[77] = new Color(204, 128, 51);
        rgb[78] = new Color(150, 74, 0);
        rgb[79] = new Color(166, 41, 41);
        rgb[80] = new Color(252, 194, 204);
        rgb[81] = new Color(232, 255, 255);
        rgb[82] = new Color(240, 219, 130);
        rgb[83] = new Color(71, 5, 8);
        rgb[84] = new Color(128, 0, 33);
        rgb[85] = new Color(222, 184, 135);
        rgb[86] = new Color(204, 84, 0);
        rgb[87] = new Color(232, 115, 82);
        rgb[88] = new Color(138, 51, 36);
        rgb[89] = new Color(189, 51, 163);
        rgb[90] = new Color(112, 41, 99);
        rgb[91] = new Color(84, 105, 120);
        rgb[92] = new Color(94, 158, 161);
        rgb[93] = new Color(145, 163, 176);
        rgb[94] = new Color(0, 107, 61);
        rgb[95] = new Color(237, 135, 46);
        rgb[96] = new Color(227, 0, 33);
        rgb[97] = new Color(255, 245, 0);
        rgb[98] = new Color(31, 77, 43);
        rgb[99] = new Color(163, 194, 173);
        rgb[100] = new Color(194, 153, 107);
        rgb[101] = new Color(120, 135, 107);
        rgb[102] = new Color(255, 240, 0);
        rgb[103] = new Color(255, 8, 0);
        rgb[104] = new Color(227, 112, 122);
        rgb[105] = new Color(0, 191, 255);
        rgb[106] = new Color(89, 38, 33);
        rgb[107] = new Color(196, 31, 59);
        rgb[108] = new Color(0, 204, 153);
        rgb[109] = new Color(150, 0, 23);
        rgb[110] = new Color(235, 77, 66);
        rgb[111] = new Color(255, 0, 56);
        rgb[112] = new Color(255, 166, 201);
        rgb[113] = new Color(179, 28, 28);
        rgb[114] = new Color(153, 186, 227);
        rgb[115] = new Color(237, 145, 33);
        rgb[116] = new Color(145, 161, 207);
        rgb[117] = new Color(171, 224, 176);
        rgb[118] = new Color(74, 150, 209);
        rgb[119] = new Color(222, 48, 99);
        rgb[120] = new Color(237, 59, 130);
        rgb[121] = new Color(0, 122, 166);
        rgb[122] = new Color(41, 82, 191);
        rgb[123] = new Color(161, 120, 89);
        rgb[124] = new Color(247, 232, 207);
        rgb[125] = new Color(54, 69, 79);
        rgb[126] = new Color(222, 255, 0);
        rgb[127] = new Color(128, 255, 0);
        rgb[128] = new Color(255, 184, 196);
        rgb[129] = new Color(204, 92, 92);
        rgb[130] = new Color(122, 64, 0);
        rgb[131] = new Color(209, 105, 31);
        rgb[132] = new Color(255, 166, 0);
        rgb[133] = new Color(153, 130, 122);
        rgb[134] = new Color(227, 66, 51);
        rgb[135] = new Color(209, 105, 31);
        rgb[136] = new Color(227, 209, 10);
        rgb[137] = new Color(250, 204, 232);
        rgb[138] = new Color(0, 71, 171);
        rgb[139] = new Color(209, 105, 31);
        rgb[140] = new Color(156, 222, 255);
        rgb[141] = new Color(0, 46, 99);
        rgb[142] = new Color(140, 145, 171);
        rgb[143] = new Color(184, 115, 51);
        rgb[144] = new Color(153, 102, 102);
        rgb[145] = new Color(255, 56, 0);
        rgb[146] = new Color(255, 128, 79);
        rgb[147] = new Color(247, 130, 120);
        rgb[148] = new Color(255, 64, 64);
        rgb[149] = new Color(138, 64, 69);
        rgb[150] = new Color(250, 237, 92);
        rgb[151] = new Color(179, 28, 28);
        rgb[152] = new Color(99, 148, 237);
        rgb[153] = new Color(255, 247, 219);
        rgb[154] = new Color(255, 247, 232);
        rgb[155] = new Color(255, 189, 217);
        rgb[156] = new Color(255, 252, 209);
        rgb[157] = new Color(219, 20, 61);
        rgb[158] = new Color(191, 0, 51);
        rgb[159] = new Color(0, 255, 255);
        rgb[160] = new Color(0, 184, 235);
        rgb[161] = new Color(255, 255, 48);
        rgb[162] = new Color(240, 224, 48);
        rgb[163] = new Color(0, 0, 140);
        rgb[164] = new Color(102, 66, 33);
        rgb[165] = new Color(92, 56, 84);
        rgb[166] = new Color(163, 0, 0);
        rgb[167] = new Color(8, 69, 125);
        rgb[168] = new Color(194, 179, 128);
        rgb[169] = new Color(153, 105, 97);
        rgb[170] = new Color(204, 92, 69);
        rgb[171] = new Color(0, 140, 140);
        rgb[172] = new Color(84, 105, 120);
        rgb[173] = new Color(184, 135, 10);
        rgb[174] = new Color(168, 168, 168);
        rgb[175] = new Color(0, 51, 33);
        rgb[176] = new Color(26, 36, 33);
        rgb[177] = new Color(189, 184, 107);
        rgb[178] = new Color(71, 61, 51);
        rgb[179] = new Color(115, 79, 150);
        rgb[180] = new Color(140, 0, 140);
        rgb[181] = new Color(0, 51, 102);
        rgb[182] = new Color(84, 107, 46);
        rgb[183] = new Color(255, 140, 0);
        rgb[184] = new Color(153, 51, 204);
        rgb[185] = new Color(120, 158, 204);
        rgb[186] = new Color(3, 191, 61);
        rgb[187] = new Color(150, 112, 214);
        rgb[188] = new Color(194, 59, 33);
        rgb[189] = new Color(232, 84, 128);
        rgb[190] = new Color(0, 51, 153);
        rgb[191] = new Color(135, 38, 87);
        rgb[192] = new Color(140, 0, 0);
        rgb[193] = new Color(232, 150, 122);
        rgb[194] = new Color(87, 3, 26);
        rgb[195] = new Color(143, 189, 143);
        rgb[196] = new Color(61, 20, 20);
        rgb[197] = new Color(71, 61, 140);
        rgb[198] = new Color(46, 79, 79);
        rgb[199] = new Color(23, 115, 69);
        rgb[200] = new Color(145, 130, 82);
        rgb[201] = new Color(255, 168, 18);
        rgb[202] = new Color(71, 61, 51);
        rgb[203] = new Color(204, 79, 92);
        rgb[204] = new Color(0, 207, 209);
        rgb[205] = new Color(148, 0, 212);
        rgb[206] = new Color(13, 128, 15);
        rgb[207] = new Color(84, 84, 84);
        rgb[208] = new Color(214, 10, 84);
        rgb[209] = new Color(168, 33, 61);
        rgb[210] = new Color(240, 48, 56);
        rgb[211] = new Color(232, 105, 43);
        rgb[212] = new Color(217, 51, 135);
        rgb[213] = new Color(250, 214, 166);
        rgb[214] = new Color(186, 79, 71);
        rgb[215] = new Color(194, 84, 194);
        rgb[216] = new Color(0, 74, 74);
        rgb[217] = new Color(153, 84, 186);
        rgb[218] = new Color(204, 0, 204);
        rgb[219] = new Color(255, 204, 163);
        rgb[220] = new Color(255, 20, 148);
        rgb[221] = new Color(255, 153, 51);
        rgb[222] = new Color(0, 191, 255);
        rgb[223] = new Color(20, 97, 189);
        rgb[224] = new Color(194, 153, 107);
        rgb[225] = new Color(237, 201, 176);
        rgb[226] = new Color(105, 105, 105);
        rgb[227] = new Color(31, 143, 255);
        rgb[228] = new Color(214, 23, 105);
        rgb[229] = new Color(133, 186, 102);
        rgb[230] = new Color(150, 112, 23);
        rgb[231] = new Color(0, 0, 156);
        rgb[232] = new Color(224, 168, 94);
        rgb[233] = new Color(194, 179, 128);
        rgb[234] = new Color(97, 64, 82);
        rgb[235] = new Color(240, 235, 214);
        rgb[236] = new Color(15, 51, 166);
        rgb[237] = new Color(125, 250, 255);
        rgb[238] = new Color(255, 0, 64);
        rgb[239] = new Color(0, 255, 255);
        rgb[240] = new Color(0, 255, 0);
        rgb[241] = new Color(112, 0, 255);
        rgb[242] = new Color(245, 186, 255);
        rgb[243] = new Color(204, 255, 0);
        rgb[244] = new Color(191, 0, 255);
        rgb[245] = new Color(64, 0, 255);
        rgb[246] = new Color(143, 0, 255);
        rgb[247] = new Color(255, 255, 0);
        rgb[248] = new Color(79, 199, 120);
        rgb[249] = new Color(150, 199, 163);
        rgb[250] = new Color(194, 153, 107);
        rgb[251] = new Color(128, 23, 23);
        rgb[252] = new Color(181, 51, 138);
        rgb[253] = new Color(245, 0, 161);
        rgb[254] = new Color(230, 171, 112);
        rgb[255] = new Color(77, 92, 84);
        rgb[256] = new Color(79, 120, 66);
        rgb[257] = new Color(255, 28, 0);
        rgb[258] = new Color(107, 84, 31);
        rgb[259] = new Color(179, 33, 33);
        rgb[260] = new Color(207, 23, 33);
        rgb[261] = new Color(227, 89, 33);
        rgb[262] = new Color(252, 143, 171);
        rgb[263] = new Color(247, 232, 143);
        rgb[264] = new Color(237, 219, 130);
        rgb[265] = new Color(255, 250, 240);
        rgb[266] = new Color(255, 191, 0);
        rgb[267] = new Color(255, 20, 148);
        rgb[268] = new Color(204, 255, 0);
        rgb[269] = new Color(255, 0, 79);
        rgb[270] = new Color(0, 69, 33);
        rgb[271] = new Color(33, 140, 33);
        rgb[272] = new Color(166, 122, 92);
        rgb[273] = new Color(0, 115, 186);
        rgb[274] = new Color(135, 97, 143);
        rgb[275] = new Color(245, 74, 138);
        rgb[276] = new Color(255, 0, 255);
        rgb[277] = new Color(255, 120, 255);
        rgb[278] = new Color(219, 133, 0);
        rgb[279] = new Color(204, 102, 102);
        rgb[280] = new Color(219, 219, 219);
        rgb[281] = new Color(227, 156, 15);
        rgb[282] = new Color(247, 247, 255);
        rgb[283] = new Color(176, 102, 0);
        rgb[284] = new Color(97, 130, 181);
        rgb[285] = new Color(212, 176, 56);
        rgb[286] = new Color(255, 214, 0);
        rgb[287] = new Color(153, 102, 20);
        rgb[288] = new Color(252, 194, 0);
        rgb[289] = new Color(255, 222, 0);
        rgb[290] = new Color(217, 166, 33);
        rgb[291] = new Color(168, 227, 161);
        rgb[292] = new Color(128, 128, 128);
        rgb[293] = new Color(128, 128, 128);
        rgb[294] = new Color(191, 191, 191);
        rgb[295] = new Color(69, 89, 69);
        rgb[296] = new Color(0, 255, 0);
        rgb[297] = new Color(0, 128, 0);
        rgb[298] = new Color(0, 168, 120);
        rgb[299] = new Color(0, 158, 107);
        rgb[300] = new Color(0, 166, 79);
        rgb[301] = new Color(102, 176, 51);
        rgb[302] = new Color(173, 255, 46);
        rgb[303] = new Color(168, 153, 135);
        rgb[304] = new Color(0, 255, 128);
        rgb[305] = new Color(102, 56, 84);
        rgb[306] = new Color(69, 107, 207);
        rgb[307] = new Color(82, 23, 250);
        rgb[308] = new Color(232, 214, 107);
        rgb[309] = new Color(64, 255, 0);
        rgb[310] = new Color(201, 0, 23);
        rgb[311] = new Color(217, 145, 0);
        rgb[312] = new Color(128, 128, 0);
        rgb[313] = new Color(222, 115, 255);
        rgb[314] = new Color(245, 0, 161);
        rgb[315] = new Color(240, 255, 240);
        rgb[316] = new Color(0, 112, 0);
        rgb[317] = new Color(255, 28, 207);
        rgb[318] = new Color(255, 105, 181);
        rgb[319] = new Color(54, 94, 59);
        rgb[320] = new Color(112, 166, 209);
        rgb[321] = new Color(252, 247, 94);
        rgb[322] = new Color(179, 237, 92);
        rgb[323] = new Color(18, 135, 8);
        rgb[324] = new Color(204, 92, 92);
        rgb[325] = new Color(227, 168, 87);
        rgb[326] = new Color(0, 64, 107);
        rgb[327] = new Color(74, 0, 130);
        rgb[328] = new Color(0, 46, 166);
        rgb[329] = new Color(255, 79, 0);
        rgb[330] = new Color(89, 79, 207);
        rgb[331] = new Color(245, 240, 237);
        rgb[332] = new Color(0, 143, 0);
        rgb[333] = new Color(255, 255, 240);
        rgb[334] = new Color(0, 168, 107);
        rgb[335] = new Color(214, 59, 61);
        rgb[336] = new Color(166, 10, 94);
        rgb[337] = new Color(250, 217, 94);
        rgb[338] = new Color(189, 217, 87);
        rgb[339] = new Color(41, 171, 135);
        rgb[340] = new Color(77, 186, 23);
        rgb[341] = new Color(194, 176, 145);
        rgb[342] = new Color(240, 230, 140);
        rgb[343] = new Color(8, 120, 48);
        rgb[344] = new Color(214, 201, 222);
        rgb[345] = new Color(38, 97, 156);
        rgb[346] = new Color(255, 255, 33);
        rgb[347] = new Color(207, 15, 33);
        rgb[348] = new Color(181, 125, 219);
        rgb[349] = new Color(230, 230, 250);
        rgb[350] = new Color(204, 204, 255);
        rgb[351] = new Color(255, 240, 245);
        rgb[352] = new Color(196, 194, 209);
        rgb[353] = new Color(148, 87, 235);
        rgb[354] = new Color(237, 130, 237);
        rgb[355] = new Color(230, 230, 250);
        rgb[356] = new Color(250, 173, 209);
        rgb[357] = new Color(150, 122, 181);
        rgb[358] = new Color(250, 161, 227);
        rgb[359] = new Color(125, 252, 0);
        rgb[360] = new Color(255, 247, 0);
        rgb[361] = new Color(255, 250, 204);
        rgb[362] = new Color(252, 214, 176);
        rgb[363] = new Color(173, 217, 230);
        rgb[364] = new Color(181, 102, 28);
        rgb[365] = new Color(230, 102, 97);
        rgb[366] = new Color(240, 128, 128);
        rgb[367] = new Color(153, 207, 237);
        rgb[368] = new Color(224, 255, 255);
        rgb[369] = new Color(250, 133, 230);
        rgb[370] = new Color(250, 250, 209);
        rgb[371] = new Color(212, 212, 212);
        rgb[372] = new Color(143, 237, 143);
        rgb[373] = new Color(240, 230, 140);
        rgb[374] = new Color(219, 209, 255);
        rgb[375] = new Color(176, 156, 217);
        rgb[376] = new Color(255, 181, 194);
        rgb[377] = new Color(255, 161, 122);
        rgb[378] = new Color(255, 153, 153);
        rgb[379] = new Color(33, 179, 171);
        rgb[380] = new Color(135, 207, 250);
        rgb[381] = new Color(120, 135, 153);
        rgb[382] = new Color(179, 140, 110);
        rgb[383] = new Color(230, 143, 171);
        rgb[384] = new Color(255, 255, 224);
        rgb[385] = new Color(199, 163, 199);
        rgb[386] = new Color(191, 255, 0);
        rgb[387] = new Color(0, 255, 0);
        rgb[388] = new Color(51, 204, 51);
        rgb[389] = new Color(28, 89, 5);
        rgb[390] = new Color(250, 240, 230);
        rgb[391] = new Color(84, 74, 79);
        rgb[392] = new Color(230, 33, 33);
        rgb[393] = new Color(255, 189, 135);
        rgb[394] = new Color(255, 0, 255);
        rgb[395] = new Color(201, 20, 122);
        rgb[396] = new Color(255, 0, 143);
        rgb[397] = new Color(171, 240, 209);
        rgb[398] = new Color(247, 245, 255);
        rgb[399] = new Color(191, 64, 0);
        rgb[400] = new Color(250, 237, 94);
        rgb[401] = new Color(97, 79, 219);
        rgb[402] = new Color(10, 217, 82);
        rgb[403] = new Color(150, 153, 171);
        rgb[404] = new Color(255, 130, 66);
        rgb[405] = new Color(128, 0, 0);
        rgb[406] = new Color(176, 48, 97);
        rgb[407] = new Color(224, 176, 255);
        rgb[408] = new Color(145, 94, 110);
        rgb[409] = new Color(240, 153, 171);
        rgb[410] = new Color(115, 194, 250);
        rgb[411] = new Color(230, 184, 59);
        rgb[412] = new Color(102, 204, 171);
        rgb[413] = new Color(0, 0, 204);
        rgb[414] = new Color(227, 5, 43);
        rgb[415] = new Color(176, 64, 54);
        rgb[416] = new Color(242, 230, 171);
        rgb[417] = new Color(3, 79, 150);
        rgb[418] = new Color(28, 54, 46);
        rgb[419] = new Color(204, 153, 204);
        rgb[420] = new Color(186, 84, 212);
        rgb[421] = new Color(0, 102, 166);
        rgb[422] = new Color(148, 112, 219);
        rgb[423] = new Color(186, 51, 133);
        rgb[424] = new Color(61, 179, 112);
        rgb[425] = new Color(122, 105, 237);
        rgb[426] = new Color(201, 219, 138);
        rgb[427] = new Color(0, 250, 153);
        rgb[428] = new Color(102, 77, 71);
        rgb[429] = new Color(0, 84, 181);
        rgb[430] = new Color(71, 209, 204);
        rgb[431] = new Color(199, 20, 133);
        rgb[432] = new Color(252, 189, 181);
        rgb[433] = new Color(26, 26, 112);
        rgb[434] = new Color(0, 74, 84);
        rgb[435] = new Color(255, 196, 13);
        rgb[436] = new Color(61, 181, 138);
        rgb[437] = new Color(245, 255, 250);
        rgb[438] = new Color(153, 255, 153);
        rgb[439] = new Color(255, 227, 224);
        rgb[440] = new Color(250, 235, 214);
        rgb[441] = new Color(150, 112, 23);
        rgb[442] = new Color(115, 168, 194);
        rgb[443] = new Color(173, 13, 0);
        rgb[444] = new Color(173, 222, 173);
        rgb[445] = new Color(48, 186, 143);
        rgb[446] = new Color(153, 122, 140);
        rgb[447] = new Color(196, 74, 140);
        rgb[448] = new Color(255, 219, 89);
        rgb[449] = new Color(33, 66, 31);
        rgb[450] = new Color(23, 69, 59);
        rgb[451] = new Color(245, 173, 199);
        rgb[452] = new Color(41, 128, 0);
        rgb[453] = new Color(250, 217, 94);
        rgb[454] = new Color(255, 222, 173);
        rgb[455] = new Color(0, 0, 128);
        rgb[456] = new Color(255, 163, 66);
        rgb[457] = new Color(255, 64, 99);
        rgb[458] = new Color(56, 224, 20);
        rgb[459] = new Color(163, 222, 237);
        rgb[460] = new Color(0, 120, 191);
        rgb[461] = new Color(204, 120, 33);
        rgb[462] = new Color(0, 128, 0);
        rgb[463] = new Color(207, 181, 59);
        rgb[464] = new Color(252, 245, 230);
        rgb[465] = new Color(120, 105, 120);
        rgb[466] = new Color(102, 48, 71);
        rgb[467] = new Color(191, 128, 130);
        rgb[468] = new Color(128, 128, 0);
        rgb[469] = new Color(107, 143, 36);
        rgb[470] = new Color(61, 51, 31);
        rgb[471] = new Color(153, 186, 115);
        rgb[472] = new Color(15, 15, 15);
        rgb[473] = new Color(184, 133, 166);
        rgb[474] = new Color(255, 128, 0);
        rgb[475] = new Color(250, 153, 3);
        rgb[476] = new Color(255, 166, 0);
        rgb[477] = new Color(255, 158, 0);
        rgb[478] = new Color(255, 69, 0);
        rgb[479] = new Color(217, 112, 214);
        rgb[480] = new Color(102, 66, 33);
        rgb[481] = new Color(64, 74, 77);
        rgb[482] = new Color(255, 110, 74);
        rgb[483] = new Color(0, 33, 71);
        rgb[484] = new Color(153, 0, 0);
        rgb[485] = new Color(0, 102, 0);
        rgb[486] = new Color(38, 59, 227);
        rgb[487] = new Color(105, 41, 97);
        rgb[488] = new Color(189, 212, 230);
        rgb[489] = new Color(176, 237, 237);
        rgb[490] = new Color(153, 117, 84);
        rgb[491] = new Color(176, 64, 54);
        rgb[492] = new Color(156, 196, 227);
        rgb[493] = new Color(222, 173, 176);
        rgb[494] = new Color(217, 138, 102);
        rgb[495] = new Color(171, 204, 240);
        rgb[496] = new Color(230, 191, 138);
        rgb[497] = new Color(237, 232, 171);
        rgb[498] = new Color(153, 250, 153);
        rgb[499] = new Color(250, 133, 230);
        rgb[500] = new Color(250, 217, 222);
        rgb[501] = new Color(204, 153, 204);
        rgb[502] = new Color(219, 112, 148);
        rgb[503] = new Color(150, 222, 209);
        rgb[504] = new Color(201, 191, 186);
        rgb[505] = new Color(237, 235, 189);
        rgb[506] = new Color(189, 153, 125);
        rgb[507] = new Color(219, 112, 148);
        rgb[508] = new Color(120, 23, 74);
        rgb[509] = new Color(255, 240, 214);
        rgb[510] = new Color(79, 199, 120);
        rgb[511] = new Color(173, 199, 207);
        rgb[512] = new Color(130, 105, 84);
        rgb[513] = new Color(207, 207, 196);
        rgb[514] = new Color(120, 222, 120);
        rgb[515] = new Color(245, 153, 194);
        rgb[516] = new Color(255, 179, 71);
        rgb[517] = new Color(255, 209, 219);
        rgb[518] = new Color(179, 158, 181);
        rgb[519] = new Color(255, 105, 97);
        rgb[520] = new Color(204, 153, 201);
        rgb[521] = new Color(252, 252, 150);
        rgb[522] = new Color(128, 0, 128);
        rgb[523] = new Color(64, 64, 71);
        rgb[524] = new Color(255, 230, 181);
        rgb[525] = new Color(255, 204, 153);
        rgb[526] = new Color(255, 217, 186);
        rgb[527] = new Color(250, 222, 173);
        rgb[528] = new Color(209, 227, 48);
        rgb[529] = new Color(240, 235, 214);
        rgb[530] = new Color(230, 227, 0);
        rgb[531] = new Color(204, 204, 255);
        rgb[532] = new Color(28, 56, 186);
        rgb[533] = new Color(0, 166, 148);
        rgb[534] = new Color(51, 18, 122);
        rgb[535] = new Color(217, 143, 89);
        rgb[536] = new Color(204, 133, 64);
        rgb[537] = new Color(247, 128, 191);
        rgb[538] = new Color(112, 28, 28);
        rgb[539] = new Color(204, 51, 51);
        rgb[540] = new Color(255, 41, 163);
        rgb[541] = new Color(237, 89, 0);
        rgb[542] = new Color(222, 0, 255);
        rgb[543] = new Color(0, 15, 138);
        rgb[544] = new Color(18, 54, 36);
        rgb[545] = new Color(252, 222, 230);
        rgb[546] = new Color(0, 120, 112);
        rgb[547] = new Color(255, 191, 204);
        rgb[548] = new Color(255, 153, 102);
        rgb[549] = new Color(232, 171, 207);
        rgb[550] = new Color(247, 143, 166);
        rgb[551] = new Color(148, 196, 115);
        rgb[552] = new Color(230, 227, 227);
        rgb[553] = new Color(143, 69, 133);
        rgb[554] = new Color(204, 153, 204);
        rgb[555] = new Color(255, 89, 54);
        rgb[556] = new Color(176, 224, 230);
        rgb[557] = new Color(255, 143, 0);
        rgb[558] = new Color(112, 28, 28);
        rgb[559] = new Color(0, 48, 84);
        rgb[560] = new Color(222, 0, 255);
        rgb[561] = new Color(204, 135, 153);
        rgb[562] = new Color(255, 117, 23);
        rgb[563] = new Color(128, 0, 128);
        rgb[564] = new Color(158, 0, 196);
        rgb[565] = new Color(161, 92, 240);
        rgb[566] = new Color(105, 54, 156);
        rgb[567] = new Color(150, 120, 181);
        rgb[568] = new Color(255, 79, 217);
        rgb[569] = new Color(79, 64, 77);
        rgb[570] = new Color(255, 54, 94);
        rgb[571] = new Color(227, 10, 92);
        rgb[572] = new Color(145, 94, 110);
        rgb[573] = new Color(227, 79, 156);
        rgb[574] = new Color(179, 69, 107);
        rgb[575] = new Color(130, 102, 69);
        rgb[576] = new Color(255, 51, 204);
        rgb[577] = new Color(227, 38, 107);
        rgb[578] = new Color(255, 0, 0);
        rgb[579] = new Color(242, 0, 61);
        rgb[580] = new Color(196, 3, 51);
        rgb[581] = new Color(237, 28, 36);
        rgb[582] = new Color(255, 38, 18);
        rgb[583] = new Color(166, 41, 41);
        rgb[584] = new Color(199, 20, 133);
        rgb[585] = new Color(171, 79, 82);
        rgb[586] = new Color(82, 46, 128);
        rgb[587] = new Color(0, 64, 64);
        rgb[588] = new Color(242, 166, 255);
        rgb[589] = new Color(214, 0, 64);
        rgb[590] = new Color(8, 145, 209);
        rgb[591] = new Color(171, 97, 204);
        rgb[592] = new Color(181, 102, 209);
        rgb[593] = new Color(176, 48, 97);
        rgb[594] = new Color(64, 71, 51);
        rgb[595] = new Color(0, 204, 204);
        rgb[596] = new Color(255, 0, 128);
        rgb[597] = new Color(250, 66, 158);
        rgb[598] = new Color(102, 77, 71);
        rgb[599] = new Color(184, 110, 120);
        rgb[600] = new Color(227, 38, 54);
        rgb[601] = new Color(255, 102, 204);
        rgb[602] = new Color(171, 153, 168);
        rgb[603] = new Color(143, 92, 92);
        rgb[604] = new Color(171, 79, 82);
        rgb[605] = new Color(102, 0, 10);
        rgb[606] = new Color(212, 0, 0);
        rgb[607] = new Color(189, 143, 143);
        rgb[608] = new Color(0, 56, 168);
        rgb[609] = new Color(0, 36, 102);
        rgb[610] = new Color(64, 105, 224);
        rgb[611] = new Color(201, 43, 145);
        rgb[612] = new Color(120, 82, 168);
        rgb[613] = new Color(224, 18, 94);
        rgb[614] = new Color(255, 0, 41);
        rgb[615] = new Color(186, 102, 41);
        rgb[616] = new Color(224, 143, 150);
        rgb[617] = new Color(168, 28, 8);
        rgb[618] = new Color(128, 69, 28);
        rgb[619] = new Color(184, 64, 13);
        rgb[620] = new Color(0, 87, 64);
        rgb[621] = new Color(140, 69, 18);
        rgb[622] = new Color(255, 102, 0);
        rgb[623] = new Color(245, 196, 48);
        rgb[624] = new Color(36, 41, 122);
        rgb[625] = new Color(255, 140, 105);
        rgb[626] = new Color(255, 145, 163);
        rgb[627] = new Color(194, 179, 128);
        rgb[628] = new Color(150, 112, 23);
        rgb[629] = new Color(237, 214, 64);
        rgb[630] = new Color(245, 163, 97);
        rgb[631] = new Color(150, 112, 23);
        rgb[632] = new Color(145, 0, 10);
        rgb[633] = new Color(79, 125, 41);
        rgb[634] = new Color(8, 38, 102);
        rgb[635] = new Color(204, 161, 54);
        rgb[636] = new Color(255, 33, 0);
        rgb[637] = new Color(255, 217, 0);
        rgb[638] = new Color(117, 255, 112);
        rgb[639] = new Color(46, 140, 87);
        rgb[640] = new Color(51, 20, 20);
        rgb[641] = new Color(255, 245, 237);
        rgb[642] = new Color(255, 186, 0);
        rgb[643] = new Color(112, 66, 20);
        rgb[644] = new Color(138, 120, 92);
        rgb[645] = new Color(0, 158, 97);
        rgb[646] = new Color(252, 15, 191);
        rgb[647] = new Color(135, 46, 23);
        rgb[648] = new Color(191, 191, 191);
        rgb[649] = new Color(204, 64, 10);
        rgb[650] = new Color(0, 122, 115);
        rgb[651] = new Color(135, 207, 235);
        rgb[652] = new Color(207, 112, 176);
        rgb[653] = new Color(107, 89, 204);
        rgb[654] = new Color(112, 128, 143);
        rgb[655] = new Color(0, 51, 153);
        rgb[656] = new Color(148, 64, 8);
        rgb[657] = new Color(15, 13, 8);
        rgb[658] = new Color(255, 250, 250);
        rgb[659] = new Color(15, 191, 252);
        rgb[660] = new Color(255, 252, 255);
        rgb[661] = new Color(166, 252, 0);
        rgb[662] = new Color(0, 255, 128);
        rgb[663] = new Color(69, 130, 181);
        rgb[664] = new Color(250, 217, 94);
        rgb[665] = new Color(227, 217, 112);
        rgb[666] = new Color(255, 204, 51);
        rgb[667] = new Color(250, 214, 166);
        rgb[668] = new Color(209, 181, 140);
        rgb[669] = new Color(250, 77, 0);
        rgb[670] = new Color(242, 133, 0);
        rgb[671] = new Color(255, 204, 0);
        rgb[672] = new Color(71, 61, 51);
        rgb[673] = new Color(140, 133, 138);
        rgb[674] = new Color(209, 240, 191);
        rgb[675] = new Color(247, 130, 120);
        rgb[676] = new Color(245, 194, 194);
        rgb[677] = new Color(0, 128, 128);
        rgb[678] = new Color(54, 117, 135);
        rgb[679] = new Color(0, 130, 128);
        rgb[680] = new Color(204, 87, 0);
        rgb[681] = new Color(227, 115, 92);
        rgb[682] = new Color(217, 191, 217);
        rgb[683] = new Color(222, 112, 161);
        rgb[684] = new Color(252, 138, 171);
        rgb[685] = new Color(10, 186, 181);
        rgb[686] = new Color(224, 140, 61);
        rgb[687] = new Color(219, 214, 209);
        rgb[688] = new Color(237, 230, 0);
        rgb[689] = new Color(255, 99, 71);
        rgb[690] = new Color(115, 107, 191);
        rgb[691] = new Color(252, 13, 54);
        rgb[692] = new Color(128, 128, 128);
        rgb[693] = new Color(0, 117, 94);
        rgb[694] = new Color(0, 115, 207);
        rgb[695] = new Color(71, 145, 207);
        rgb[696] = new Color(222, 171, 135);
        rgb[697] = new Color(181, 115, 130);
        rgb[698] = new Color(48, 214, 199);
        rgb[699] = new Color(0, 255, 240);
        rgb[700] = new Color(161, 214, 181);
        rgb[701] = new Color(130, 54, 54);
        rgb[702] = new Color(138, 74, 107);
        rgb[703] = new Color(102, 3, 61);
        rgb[704] = new Color(0, 51, 171);
        rgb[705] = new Color(217, 0, 77);
        rgb[706] = new Color(135, 120, 194);
        rgb[707] = new Color(84, 105, 148);
        rgb[708] = new Color(255, 179, 0);
        rgb[709] = new Color(61, 209, 112);
        rgb[710] = new Color(18, 10, 143);
        rgb[711] = new Color(64, 102, 245);
        rgb[712] = new Color(255, 112, 255);
        rgb[713] = new Color(99, 82, 71);
        rgb[714] = new Color(92, 145, 230);
        rgb[715] = new Color(255, 255, 102);
        rgb[716] = new Color(0, 69, 33);
        rgb[717] = new Color(122, 18, 18);
        rgb[718] = new Color(173, 23, 33);
        rgb[719] = new Color(224, 173, 33);
        rgb[720] = new Color(153, 0, 0);
        rgb[721] = new Color(255, 204, 0);
        rgb[722] = new Color(212, 0, 64);
        rgb[723] = new Color(242, 230, 171);
        rgb[724] = new Color(196, 179, 89);
        rgb[725] = new Color(199, 8, 20);
        rgb[726] = new Color(66, 179, 173);
        rgb[727] = new Color(227, 66, 51);
        rgb[728] = new Color(161, 92, 240);
        rgb[729] = new Color(143, 0, 255);
        rgb[730] = new Color(128, 0, 255);
        rgb[731] = new Color(135, 0, 176);
        rgb[732] = new Color(237, 130, 237);
        rgb[733] = new Color(64, 130, 110);
        rgb[734] = new Color(148, 38, 36);
        rgb[735] = new Color(158, 28, 54);
        rgb[736] = new Color(217, 28, 130);
        rgb[737] = new Color(255, 161, 138);
        rgb[738] = new Color(158, 0, 255);
        rgb[739] = new Color(0, 66, 66);
        rgb[740] = new Color(99, 84, 82);
        rgb[741] = new Color(245, 222, 179);
        rgb[742] = new Color(255, 255, 255);
        rgb[743] = new Color(245, 245, 245);
        rgb[744] = new Color(163, 173, 209);
        rgb[745] = new Color(255, 66, 163);
        rgb[746] = new Color(252, 107, 133);
        rgb[747] = new Color(201, 161, 219);
        rgb[748] = new Color(115, 135, 120);
        rgb[749] = new Color(15, 77, 145);
        rgb[750] = new Color(255, 255, 0);
        rgb[751] = new Color(240, 204, 0);
        rgb[752] = new Color(255, 212, 0);
        rgb[753] = new Color(255, 240, 0);
        rgb[754] = new Color(255, 255, 51);
        rgb[755] = new Color(153, 204, 51);
        rgb[756] = new Color(0, 20, 168);
        rgb[757] = new Color(43, 23, 8);

        /*Arrays.sort(rgb, new Comparator<Color>() {
            @Override
            public int compare(Color c1, Color c2) {
              return Float.compare(((float) c1.getRed() * 0.299f + (float) c1.getGreen() * 0.587f
                    + (float) c1.getBlue() * 0.114f) / 256f, ((float) c2.getRed() * 0.299f + (float) c2.getGreen()
                    * 0.587f + (float) c2.getBlue() * 0.114f) / 256f);
            }
        });*/
        Arrays.sort(rgb, new Comparator<Color>() {
            @Override
            public int compare(Color o1, Color o2) {
                return o1.getRGB() - o2.getRGB();
            }
        });
        return rgb;

    }

    public BufferedImage getBufferedImage() {

        Color[] scale = this.getColorScale();
        BufferedImage b = new BufferedImage(scale.length, 20, 4);

        System.out.println(b.getHeight());
        for (int x = 0; x < scale.length; x++) {
            int rgb = scale[x].getRGB();
            for (int y = 0; y < 20; y++) {
                b.setRGB(x, y, rgb);
            }
        }

        return b;

    }

    public static void main(String[] args) {

        try {
            AureaComplete aureaComplete = new AureaComplete();
            ImageIO.write(aureaComplete.getBufferedImage(), "png", new File("/home/aurea/scale_aureaComplete.png"));
        } catch (IOException ex) {
            Logger.getLogger(PseudoRainbow.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
}
