import React, { useState, useEffect } from 'react';
import { Link } from 'react-router-dom';
import {
  Card,
  CardContent,
  Grid,
  Typography,
  Button,
  TextField,
  Table,
  TableBody,
  TableCell,
  TableContainer,
  TableHead,
  TableRow,
} from '@mui/material';

// Project imports
import Breadcrumb from 'component/Breadcrumb';

const OrderHistory = () => {
  const [startDate, setStartDate] = useState('');
  const [endDate, setEndDate] = useState('');
  const [tableData, setTableData] = useState([]);

  useEffect(() => {
    const today = new Date().toISOString().split('T')[0];
    setStartDate(today);
    setEndDate(today);
    fetchData(today, today);
  }, []);

  const fetchData = async (start, end) => {
    try {
      const response = await fetch('http://localhost:38998/ord/l', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          code: 'app-order-trans',
          axn: 'l',
          data: [
            {
              current_uid: 'tester',
              start_dt: start,
              end_dt: end,
              axn: 'history-list',
            },
          ],
        }),
      });

      if (!response.ok) {
        throw new Error(`HTTP error! Status: ${response.status}`);
      }

      const result = await response.json();
      if (result?.data?.data) {
        setTableData(result.data.data);
      } else {
        console.error('Unexpected table structure:', result);
        setTableData([]);
      }
    } catch (error) {
      console.error('Failed to fetch table data:', error);
      setTableData([]);
    }
  };

  const handleSubmit = () => {
    if (startDate && endDate) {
      fetchData(startDate, endDate);
    }
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
          Order History
        </Typography>
      </Breadcrumb>

      <Card sx={{ mb: 2 }}>
        <CardContent>
          <Grid container spacing={2}>
            <Grid item xs={12} sm={6} md={4}>
              <TextField
                fullWidth
                label="Start Date"
                type="date"
                value={startDate}
                onChange={(e) => setStartDate(e.target.value)}
                InputLabelProps={{ shrink: true }}
              />
            </Grid>
            <Grid item xs={12} sm={6} md={4}>
              <TextField
                fullWidth
                label="End Date"
                type="date"
                value={endDate}
                onChange={(e) => setEndDate(e.target.value)}
                InputLabelProps={{ shrink: true }}
              />
            </Grid>
            <Grid item xs={12} sm={6} md={4} display="flex" alignItems="center">
              <Button variant="contained" onClick={handleSubmit}>
                SEARCH
              </Button>
            </Grid>
          </Grid>
        </CardContent>
      </Card>

      <TableContainer component={Card}>
        <Table>
          <TableHead>
            <TableRow>
              <TableCell>Order ID</TableCell>
              <TableCell align="center">Document No</TableCell>
              <TableCell align="center">Modified On</TableCell>
              <TableCell align="center">Modified By</TableCell>
              <TableCell align="center">Transaction Type</TableCell>
              <TableCell align="center">Status</TableCell>
              <TableCell align="center">Table No</TableCell>
              <TableCell align="center">Room No</TableCell>
              <TableCell align="right">Amount</TableCell>
            </TableRow>
          </TableHead>
          <TableBody>
            {tableData.length > 0 ? (
              tableData.map((order) => (
                // <TableRow key={order.order_trans_id}>
                <TableRow 
                  key={order.order_trans_id}
                  sx={{ bgcolor: order.tr_status === 'X' ? '#C96868' : 'inherit' }}
                >
                  <TableCell>{order.order_trans_id}</TableCell>
                  <TableCell align="center">{order.doc_no}</TableCell>
                  <TableCell align="center">{new Date(order.modified_on).toLocaleDateString()}</TableCell>
                  <TableCell align="center">{order.modified_by}</TableCell>
                  <TableCell align="center">{order.tr_type_desc}</TableCell>
                  <TableCell align="center">{order.tr_status}</TableCell>
                  <TableCell align="center">{order.table_no}</TableCell>
                  <TableCell align="center">{order.room_no}</TableCell>
                  <TableCell align="right">RM {order.amt}</TableCell>
                </TableRow>
              ))
            ) : (
              <TableRow>
                <TableCell colSpan={9} align="center">
                  No Data Found
                </TableCell>
              </TableRow>
            )}
          </TableBody>
        </Table>
      </TableContainer>
    </>
  );
};

export default OrderHistory;
