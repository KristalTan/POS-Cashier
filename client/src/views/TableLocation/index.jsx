import React, { useState, useEffect } from 'react';
import { Link, useNavigate } from 'react-router-dom';

// material-ui
import { Card, Grid, Typography, Box, Tab, Avatar } from '@mui/material';
import TabContext from '@mui/lab/TabContext';
import TabList from '@mui/lab/TabList';

// project import
import Breadcrumb from 'component/Breadcrumb';
import { gridSpacing } from 'config.js';

const TableLocation = () => {
  const [selectedZone, setSelectedZone] = useState('All');
  const [table, setTable] = useState([]); // State for table data
  const [table_sec, setTableSec] = useState([]); // State for table sections
  const navigate = useNavigate();

  const handleChangeZone = (event, newValue) => {
    setSelectedZone(newValue);
  };

  useEffect(() => {
    const fetchTableLocation = async () => {
      try {
        const response = await fetch('http://localhost:38998/ord/tl', {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
          },
          body: JSON.stringify({
            code: 'app-order-trans',
            axn: 'tl',
            data: [
              {
                current_uid: 'tester',
              },
            ],
          }),
        });

        if (!response.ok) {
          throw new Error(`HTTP error! Status: ${response.status}`);
        }

        const result = await response.json();
        if (result && result.data && Array.isArray(result.data.data)) {
          setTable(result.data.data); // Update table state with fetched data
        } else {
          console.error('Unexpected table structure:', result);
        }
      } catch (error) {
        console.error('Failed to fetch tables:', error);
      }
    };

    const fetchTableSection = async () => {
      try {
        const response = await fetch('http://localhost:38998/ts/l', {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
          },
          body: JSON.stringify({
            code: 'setting-table-sec',
            axn: 'l',
            data: [
              {
                current_uid: 'tester',
                is_in_use: 1,
              },
            ],
          }),
        });

        if (!response.ok) {
          throw new Error(`HTTP error! Status: ${response.status}`);
        }

        const result = await response.json();
        if (result && result.data && Array.isArray(result.data.data)) {
          setTableSec(result.data.data); // Update table sections state with fetched data
        } else {
          console.error('Unexpected table section structure:', result);
        }
      } catch (error) {
        console.error('Failed to fetch table sections:', error);
      }
    };

    fetchTableLocation();
    fetchTableSection();
  }, []);

  // Calculate the total available and occupied tables
  const totalAvailableTables = table.filter((t) => t.is_occ === 0).length;
  const totalOccupiedTables = table.filter((t) => t.is_occ === 1).length;

  // Function to filter and render TableCards based on the selected table section
  const renderTableCards = () => {
    const filteredTables =
      selectedZone === 'All'
        ? table
        : table.filter((t) => t.table_section_name === selectedZone);

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
                navigate('/order', {
                  state: { 
                    dineOption: 'Dine In', 
                    table: t.order_trans_table_id 
                  }
                });
              } else {
                navigate('/payment', {
                  state: { 
                    orderTransId: t.order_trans_id 
                  }
                });
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

export default TableLocation;
