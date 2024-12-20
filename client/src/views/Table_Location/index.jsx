import React, { useState } from 'react';
import { Link, useNavigate } from 'react-router-dom';

// material-ui
import { Card, Grid, Typography, Box, Tab, Avatar } from '@mui/material';
import TabContext from '@mui/lab/TabContext';
import TabList from '@mui/lab/TabList';

// project import
import Breadcrumb from 'component/Breadcrumb';
import { gridSpacing } from 'config.js';

const table = [
  {
    order_trans_table_id: '1',
    table_section_name: "Zone A",
    table_desc: "A1",
    is_occ: 1,
    order_trans_id: 'order-1',
    doc_no: '',
    modified_on: '2024-11-30 12:15:00',
    modified_by: 'Ayam',
    tr_date:'2024-11-30 12:15:00',
    tr_type_desc: 'Type 1',
    tr_status: 'Occupied',
    amt: 100.0,
    pax: 4
  },
  {
    order_trans_table_id: '2',
    table_section_name: "Zone A",
    table_desc: "A2",
    is_occ: 1,
    order_trans_id: 'order-2',
    doc_no: 'doc-2',
    modified_on: '2024-11-30 12:15:00',
    modified_by: 'Ayam',
    tr_date:'2024-11-30 12:15:00',
    tr_type_desc: 'Type 2',
    tr_status: 'Occupied',
    amt: 200.0,
    pax: 2
  },
  {
    order_trans_table_id: '3',
    table_section_name: "Zone B",
    table_desc: "B1",
    is_occ: 0,
    order_trans_id: null,
    doc_no: null,
    modified_on: null,
    modified_by: null,
    tr_date: null,
    tr_type_desc: 'Available',
    tr_status: 'Available',
    amt: 0.0,
    pax: 0
  },
  {
    order_trans_table_id: '4',
    table_section_name: "Zone C",
    table_desc: "C1",
    is_occ: 0,
    order_trans_id: null,
    doc_no: null,
    modified_on: null,
    modified_by: null,
    tr_date: null,
    tr_type_desc: 'Available',
    tr_status: 'Available',
    amt: 0.0,
    pax: 0
  },
  {
    order_trans_table_id: '5',
    table_section_name: "Zone B",
    table_desc: "B2",
    is_occ: 0,
    order_trans_id: null,
    doc_no: null,
    modified_on: null,
    modified_by: null,
    tr_date: null,
    tr_type_desc: 'Available',
    tr_status: 'Available',
    amt: 0.0,
    pax: 0
  },
  {
    order_trans_table_id: '6',
    table_section_name: "Zone C",
    table_desc: "C2",
    is_occ: 1,
    order_trans_id: '000001',
    doc_no: '',
    modified_on: '2024-11-30 12:15:00',
    modified_by: 'Ayam',
    tr_date:'2024-11-30 12:15:00',
    tr_type_desc: 'Type 2',
    tr_status: 'Occupied',
    amt: 200.0,
    pax: 2
  }
];

const table_sec = [
  { table_section_id: 1, table_section_name: "Zone A", is_in_use: 1, display_seq: 12 },
  { table_section_id: 2, table_section_name: "Zone B", is_in_use: 1, display_seq: 10 },
  { table_section_id: 3, table_section_name: "Zone C", is_in_use: 1, display_seq: 8 }
];

const Table_Location = () => {
  const [selectedZone, setSelectedZone] = useState('All');
  const navigate = useNavigate();

  const handleChangeZone = (event, newValue) => {
    setSelectedZone(newValue);
  };

  // Calculate the total available and occupied tables
  const totalAvailableTables = table.filter((t) => t.is_occ === 0).length;
  const totalOccupiedTables = table.filter((t) => t.is_occ === 1).length;

  // Function to filter and render TableCards based on the selected table section
  const renderTableCards = () => {
    const filteredTables =
      selectedZone === 'All'
        ? table
        : table.filter(
            (t) => t.table_section_name === selectedZone
          );

    return (
      <Box
        display="grid"
        gridTemplateColumns="repeat(auto-fill, minmax(200px, 1fr))"
        gap="10px"
      >
        {filteredTables.map((t) => (
          <Box
            key={t.order_trans_table_id}
            backgroundColor={t.is_occ ? "#9BA4B4" : "#F5F5DC"} // Grey if occupied, green if available
            display="flex"
            flexDirection="column"
            sx={{
              '&:hover': {
                border: "2px solid #191717",
              },
            }}
            onClick={() => {
              if (!t.is_occ) {
                navigate('/order');
              } else if (t.is_occ) {
                navigate('/payment');
              }
            }}
          >
            <Box margin={4}>
              <Typography variant="h7" color={t.is_occ ? "#FFFFFF" : "#557C56"}>
                {t.table_desc}
              </Typography>
              <Typography variant="body2" color={t.is_occ ? "#FFFFFF" : "#557C56"}>
                {t.is_occ ? `${t.pax} Pax - Occupied` : 'Available'}
              </Typography>
            </Box>
          </Box>
        ))}
      </Box>
    );
  };

  return (
    <>
      <Breadcrumb>
        <Typography
          component={Link}
          to="/"
          variant="subtitle2"
          color="inherit"
          className="link-breadcrumb"
        >
          Home
        </Typography>
        <Typography variant="subtitle2" color="primary" className="link-breadcrumb">
          Table Location
        </Typography>
      </Breadcrumb>

      <Grid container spacing={gridSpacing} padding="0px">
        {/* Grid for Legend */}
        <Grid item xs={12} sx={{ paddingBottom: '20px', display: 'flex', gap: '20px' }}>
          <Box display="flex" alignItems="center" gap="10px">
            <Avatar sx={{ bgcolor: '#F5F5DC', width: 24, height: 24, border: "1px solid #191717" }} />
            <Typography variant="h6" color="textPrimary">
              Available: {totalAvailableTables}
            </Typography>
          </Box>
          <Box display="flex" alignItems="center" gap="10px">
            <Avatar sx={{ bgcolor: '#9BA4B4', width: 24, height: 24, border: "1px solid #191717" }} />
            <Typography variant="h6" color="textPrimary">
              Occupied: {totalOccupiedTables}
            </Typography>
          </Box>
        </Grid>

        {/* Grid for Menu Category */}
        <Grid item xs={12}>
          <Card
            sx={{
              width: '100%',
              margin: 'auto',
              display: 'flex',
              flexDirection: 'column',
            }}
          >
            <Box sx={{ width: '100%', typography: 'body1' }}>
              <TabContext value={selectedZone}>
                <Box sx={{ borderBottom: 1, borderColor: 'divider' }}>
                  <TabList
                    onChange={handleChangeZone}
                    variant="scrollable"
                    scrollButtons="auto"
                    allowScrollButtonsMobile
                  >
                    <Tab label="All" value="All" />
                    {table_sec.map((section) => (
                      <Tab
                        key={section.table_section_id}
                        label={section.table_section_name}
                        value={section.table_section_name}
                      />
                    ))}
                  </TabList>
                </Box>
                <Box
                  sx={{
                    p: '20px',
                    overflow: 'auto',
                    height: {
                      xs: 'calc(100vh - 200px)',
                      sm: 'calc(100vh - 220px)',
                      md: 'calc(100vh - 240px)',
                      lg: 'calc(100vh - 260px)',
                      xl: 'calc(100vh - 280px)',
                    },
                    '::-webkit-scrollbar': {
                      display: 'none',
                    },
                    scrollbarWidth: 'none',
                  }}
                >
                  {renderTableCards()}
                </Box>
              </TabContext>
            </Box>
          </Card>
        </Grid>
      </Grid>
    </>
  );
};

export default Table_Location;