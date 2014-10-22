/**********************************************************************/
/*   ____  ____                                                       */
/*  /   /\/   /                                                       */
/* /___/  \  /                                                        */
/* \   \   \/                                                       */
/*  \   \        Copyright (c) 2003-2009 Xilinx, Inc.                */
/*  /   /          All Right Reserved.                                 */
/* /---/   /\                                                         */
/* \   \  /  \                                                      */
/*  \___\/\___\                                                    */
/***********************************************************************/

/* This file is designed for use with ISim build 0x7708f090 */

#define XSI_HIDE_SYMBOL_SPEC true
#include "xsi.h"
#include <memory.h>
#ifdef __GNUC__
#include <stdlib.h>
#else
#include <malloc.h>
#define alloca _alloca
#endif
static const char *ng0 = "C:/Users/tlenzi/Desktop/GLIB/amc_glib/trunk/glib_v3/fw/fpga/prj/ipbus_slave/src/clock_bridge_strobes.vhd";
extern char *IEEE_P_2592010699;

unsigned char ieee_p_2592010699_sub_1690584930_503743352(char *, unsigned char );
unsigned char ieee_p_2592010699_sub_1744673427_503743352(char *, char *, unsigned int , unsigned int );


static void work_a_1511911918_3212880686_p_0(char *t0)
{
    char *t1;
    unsigned char t2;
    char *t3;
    char *t4;
    unsigned char t5;
    unsigned char t6;
    char *t7;
    char *t8;
    char *t9;
    char *t10;
    char *t11;
    char *t12;
    int t13;
    int t14;
    int t15;
    int t16;
    int t17;
    unsigned int t18;
    unsigned int t19;
    unsigned int t20;
    int t21;
    int t22;
    unsigned int t23;
    unsigned int t24;
    unsigned int t25;
    char *t26;
    int t27;
    int t28;
    unsigned int t29;
    unsigned int t30;
    unsigned int t31;
    char *t32;
    unsigned char t33;
    unsigned char t34;
    char *t35;
    char *t36;
    int t37;
    int t38;
    unsigned int t39;
    unsigned int t40;
    unsigned int t41;
    char *t42;
    unsigned char t43;
    unsigned char t44;
    char *t45;
    int t46;
    int t47;
    unsigned int t48;
    unsigned int t49;
    unsigned int t50;
    char *t51;
    char *t52;
    char *t53;
    char *t54;
    char *t55;

LAB0:    xsi_set_current_line(28, ng0);
    t1 = (t0 + 1152U);
    t2 = ieee_p_2592010699_sub_1744673427_503743352(IEEE_P_2592010699, t1, 0U, 0U);
    if (t2 != 0)
        goto LAB2;

LAB4:
LAB3:    t1 = (t0 + 3720);
    *((int *)t1) = 1;

LAB1:    return;
LAB2:    xsi_set_current_line(30, ng0);
    t3 = (t0 + 1032U);
    t4 = *((char **)t3);
    t5 = *((unsigned char *)t4);
    t6 = (t5 == (unsigned char)3);
    if (t6 != 0)
        goto LAB5;

LAB7:    xsi_set_current_line(34, ng0);
    t13 = (6U - 1);
    t1 = (t0 + 6585);
    *((int *)t1) = 0;
    t3 = (t0 + 6589);
    *((int *)t3) = t13;
    t14 = 0;
    t15 = t13;

LAB8:    if (t14 <= t15)
        goto LAB9;

LAB11:
LAB6:    goto LAB3;

LAB5:    xsi_set_current_line(31, ng0);
    t3 = xsi_get_transient_memory(6U);
    memset(t3, 0, 6U);
    t7 = t3;
    memset(t7, (unsigned char)2, 6U);
    t8 = (t0 + 3816);
    t9 = (t8 + 56U);
    t10 = *((char **)t9);
    t11 = (t10 + 56U);
    t12 = *((char **)t11);
    memcpy(t12, t3, 6U);
    xsi_driver_first_trans_fast(t8);
    goto LAB6;

LAB9:    xsi_set_current_line(37, ng0);
    t4 = (t0 + 1352U);
    t7 = *((char **)t4);
    t4 = (t0 + 6585);
    t16 = *((int *)t4);
    t17 = (t16 - 5);
    t18 = (t17 * -1);
    xsi_vhdl_check_range_of_index(5, 0, -1, *((int *)t4));
    t19 = (1U * t18);
    t20 = (0 + t19);
    t8 = (t7 + t20);
    t2 = *((unsigned char *)t8);
    t5 = (t2 == (unsigned char)3);
    if (t5 != 0)
        goto LAB12;

LAB14:
LAB13:
LAB10:    t1 = (t0 + 6585);
    t14 = *((int *)t1);
    t3 = (t0 + 6589);
    t15 = *((int *)t3);
    if (t14 == t15)
        goto LAB11;

LAB18:    t13 = (t14 + 1);
    t14 = t13;
    t4 = (t0 + 6585);
    *((int *)t4) = t14;
    goto LAB8;

LAB12:    xsi_set_current_line(39, ng0);
    t9 = (t0 + 1832U);
    t10 = *((char **)t9);
    t9 = (t0 + 6585);
    t21 = *((int *)t9);
    t22 = (t21 - 5);
    t23 = (t22 * -1);
    xsi_vhdl_check_range_of_index(5, 0, -1, *((int *)t9));
    t24 = (1U * t23);
    t25 = (0 + t24);
    t11 = (t10 + t25);
    t6 = *((unsigned char *)t11);
    t12 = (t0 + 1992U);
    t26 = *((char **)t12);
    t12 = (t0 + 6585);
    t27 = *((int *)t12);
    t28 = (t27 - 5);
    t29 = (t28 * -1);
    xsi_vhdl_check_range_of_index(5, 0, -1, *((int *)t12));
    t30 = (1U * t29);
    t31 = (0 + t30);
    t32 = (t26 + t31);
    t33 = *((unsigned char *)t32);
    t34 = (t6 == t33);
    if (t34 != 0)
        goto LAB15;

LAB17:
LAB16:    goto LAB13;

LAB15:    xsi_set_current_line(41, ng0);
    t35 = (t0 + 1832U);
    t36 = *((char **)t35);
    t35 = (t0 + 6585);
    t37 = *((int *)t35);
    t38 = (t37 - 5);
    t39 = (t38 * -1);
    xsi_vhdl_check_range_of_index(5, 0, -1, *((int *)t35));
    t40 = (1U * t39);
    t41 = (0 + t40);
    t42 = (t36 + t41);
    t43 = *((unsigned char *)t42);
    t44 = ieee_p_2592010699_sub_1690584930_503743352(IEEE_P_2592010699, t43);
    t45 = (t0 + 6585);
    t46 = *((int *)t45);
    t47 = (t46 - 5);
    t48 = (t47 * -1);
    t49 = (1 * t48);
    t50 = (0U + t49);
    t51 = (t0 + 3816);
    t52 = (t51 + 56U);
    t53 = *((char **)t52);
    t54 = (t53 + 56U);
    t55 = *((char **)t54);
    *((unsigned char *)t55) = t44;
    xsi_driver_first_trans_delta(t51, t50, 1, 0LL);
    goto LAB16;

}

static void work_a_1511911918_3212880686_p_1(char *t0)
{
    char *t1;
    unsigned char t2;
    char *t3;
    char *t4;
    unsigned char t5;
    unsigned char t6;
    char *t7;
    char *t8;
    char *t9;
    char *t10;
    char *t11;
    char *t12;
    int t13;
    int t14;
    int t15;
    int t16;
    int t17;
    unsigned int t18;
    unsigned int t19;
    unsigned int t20;
    int t21;
    int t22;
    unsigned int t23;
    unsigned int t24;
    unsigned int t25;
    int t26;
    int t27;
    unsigned int t28;
    unsigned int t29;
    unsigned int t30;
    char *t31;
    char *t32;
    char *t33;
    char *t34;
    char *t35;

LAB0:    xsi_set_current_line(53, ng0);
    t1 = (t0 + 1472U);
    t2 = ieee_p_2592010699_sub_1744673427_503743352(IEEE_P_2592010699, t1, 0U, 0U);
    if (t2 != 0)
        goto LAB2;

LAB4:
LAB3:    t1 = (t0 + 3736);
    *((int *)t1) = 1;

LAB1:    return;
LAB2:    xsi_set_current_line(55, ng0);
    t3 = (t0 + 1032U);
    t4 = *((char **)t3);
    t5 = *((unsigned char *)t4);
    t6 = (t5 == (unsigned char)3);
    if (t6 != 0)
        goto LAB5;

LAB7:    xsi_set_current_line(60, ng0);
    t13 = (6U - 1);
    t1 = (t0 + 6593);
    *((int *)t1) = 0;
    t3 = (t0 + 6597);
    *((int *)t3) = t13;
    t14 = 0;
    t15 = t13;

LAB8:    if (t14 <= t15)
        goto LAB9;

LAB11:
LAB6:    goto LAB3;

LAB5:    xsi_set_current_line(56, ng0);
    t3 = xsi_get_transient_memory(6U);
    memset(t3, 0, 6U);
    t7 = t3;
    memset(t7, (unsigned char)2, 6U);
    t8 = (t0 + 3880);
    t9 = (t8 + 56U);
    t10 = *((char **)t9);
    t11 = (t10 + 56U);
    t12 = *((char **)t11);
    memcpy(t12, t3, 6U);
    xsi_driver_first_trans_fast_port(t8);
    xsi_set_current_line(57, ng0);
    t1 = xsi_get_transient_memory(6U);
    memset(t1, 0, 6U);
    t3 = t1;
    memset(t3, (unsigned char)2, 6U);
    t4 = (t0 + 3944);
    t7 = (t4 + 56U);
    t8 = *((char **)t7);
    t9 = (t8 + 56U);
    t10 = *((char **)t9);
    memcpy(t10, t1, 6U);
    xsi_driver_first_trans_fast(t4);
    goto LAB6;

LAB9:    xsi_set_current_line(63, ng0);
    t4 = (t0 + 1832U);
    t7 = *((char **)t4);
    t4 = (t0 + 6593);
    t16 = *((int *)t4);
    t17 = (t16 - 5);
    t18 = (t17 * -1);
    xsi_vhdl_check_range_of_index(5, 0, -1, *((int *)t4));
    t19 = (1U * t18);
    t20 = (0 + t19);
    t8 = (t7 + t20);
    t2 = *((unsigned char *)t8);
    t9 = (t0 + 1992U);
    t10 = *((char **)t9);
    t9 = (t0 + 6593);
    t21 = *((int *)t9);
    t22 = (t21 - 5);
    t23 = (t22 * -1);
    xsi_vhdl_check_range_of_index(5, 0, -1, *((int *)t9));
    t24 = (1U * t23);
    t25 = (0 + t24);
    t11 = (t10 + t25);
    t5 = *((unsigned char *)t11);
    t6 = (t2 != t5);
    if (t6 != 0)
        goto LAB12;

LAB14:    xsi_set_current_line(71, ng0);
    t1 = (t0 + 6593);
    t13 = *((int *)t1);
    t16 = (t13 - 5);
    t18 = (t16 * -1);
    t19 = (1 * t18);
    t20 = (0U + t19);
    t3 = (t0 + 3880);
    t4 = (t3 + 56U);
    t7 = *((char **)t4);
    t8 = (t7 + 56U);
    t9 = *((char **)t8);
    *((unsigned char *)t9) = (unsigned char)2;
    xsi_driver_first_trans_delta(t3, t20, 1, 0LL);

LAB13:
LAB10:    t1 = (t0 + 6593);
    t14 = *((int *)t1);
    t3 = (t0 + 6597);
    t15 = *((int *)t3);
    if (t14 == t15)
        goto LAB11;

LAB15:    t13 = (t14 + 1);
    t14 = t13;
    t4 = (t0 + 6593);
    *((int *)t4) = t14;
    goto LAB8;

LAB12:    xsi_set_current_line(65, ng0);
    t12 = (t0 + 6593);
    t26 = *((int *)t12);
    t27 = (t26 - 5);
    t28 = (t27 * -1);
    t29 = (1 * t28);
    t30 = (0U + t29);
    t31 = (t0 + 3880);
    t32 = (t31 + 56U);
    t33 = *((char **)t32);
    t34 = (t33 + 56U);
    t35 = *((char **)t34);
    *((unsigned char *)t35) = (unsigned char)3;
    xsi_driver_first_trans_delta(t31, t30, 1, 0LL);
    xsi_set_current_line(67, ng0);
    t1 = (t0 + 1992U);
    t3 = *((char **)t1);
    t1 = (t0 + 6593);
    t13 = *((int *)t1);
    t16 = (t13 - 5);
    t18 = (t16 * -1);
    xsi_vhdl_check_range_of_index(5, 0, -1, *((int *)t1));
    t19 = (1U * t18);
    t20 = (0 + t19);
    t4 = (t3 + t20);
    t2 = *((unsigned char *)t4);
    t5 = ieee_p_2592010699_sub_1690584930_503743352(IEEE_P_2592010699, t2);
    t7 = (t0 + 6593);
    t17 = *((int *)t7);
    t21 = (t17 - 5);
    t23 = (t21 * -1);
    t24 = (1 * t23);
    t25 = (0U + t24);
    t8 = (t0 + 3944);
    t9 = (t8 + 56U);
    t10 = *((char **)t9);
    t11 = (t10 + 56U);
    t12 = *((char **)t11);
    *((unsigned char *)t12) = t5;
    xsi_driver_first_trans_delta(t8, t25, 1, 0LL);
    goto LAB13;

}


extern void work_a_1511911918_3212880686_init()
{
	static char *pe[] = {(void *)work_a_1511911918_3212880686_p_0,(void *)work_a_1511911918_3212880686_p_1};
	xsi_register_didat("work_a_1511911918_3212880686", "isim/test_xclock_strobes_isim_beh.exe.sim/work/a_1511911918_3212880686.didat");
	xsi_register_executes(pe);
}
