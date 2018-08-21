# LSI_Fusion_MPT_CARD_Zabbix-Template

**NB!!! only for linux !!!**

Here is a zabbix template for LSI Fusion MPT raid adapter (also known as Dell PERC H200 and IBM BladeCenter HS23)

Template uses SAS2IRCU to get access to adapter, you can download this program here: http://www.supermicro.com/support/faqs/data_lib/FAQ_9633_SAS2IRCU_Phase_5.0-5.00.00.00.zip

Template uses discovery script to find configured raid arrays and drives.

### Installation

On zabbix agent:

1) Put *sas2ircu* binary to `/etc/zabbix`
2) Put discovery and data-fetch scripts to `/etc/zabbix/scripts`
3) Put *LSI.conf* with UserParamerets to `/etc/zabbix/zabbix_agentd.d`
4) Restart zabbix

On zabbix server:

Import template *LSI_Fusion_MPT_CARD.xml* and ENJOY!

### Screenshot

![Zabbix_LSI_Fusion_MPT_SAS2.png](/Zabbix_LSI_Fusion_MPT_SAS2.png?raw=true "Screenshot")
