import React, { useState, useEffect } from 'react';
import { Link, useLocation } from 'react-router-dom';
import {Card, CardContent, Grid, Typography, Button, IconButton, Table, TableBody, TableCell, TableContainer, TableHead, TableRow, Divider,Box, Modal,TextField,} from '@mui/material';
import DeleteIcon from '@mui/icons-material/Delete';
import Breadcrumb from 'component/Breadcrumb';
import { gridSpacing } from 'config.js';

const PaymentBillings = () => {
  const [tableData, setTableData] = useState([]);
  const [itemDetails, setItemDetails] = useState([]);
  const [modalOpen, setModalOpen] = useState(false);
  const [selectedOrder, setSelectedOrder] = useState(null);
  const [selectedItem, setSelectedItem] = useState(null);
  const [discount, setDiscount] = useState('');
  const location = useLocation();
  const { orderTransId } = location.state || {};

  useEffect(() => {
    if (orderTransId) {
      fetchOrderTransactionListItem(orderTransId);
    }
  }, [orderTransId]);

  useEffect(() => {
    const fetchOrderTransactionList = async () => {
      try {
        const response = await fetch('http://localhost:38998/ord/l', {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
          },
          body: JSON.stringify({
            code: 'app-order-trans',
            axn: 'l',
            data: [{
              current_uid: 'tester',
              start_dt: '2024-11-24',
              end_dt: '2024-11-25',
              axn: 'pending-list',
            }],
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
        }
      } catch (error) {
        console.error('Failed to fetch table data:', error);
      }
    };

    fetchOrderTransactionList();
  }, []);

  const fetchOrderTransactionListItem = async (orderTransId) => {
    try {
      const response = await fetch('http://localhost:38998/ord/il', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          code: 'app-order-trans',
          axn: 'il',
          data: [
            {
              current_uid: 'tester',
              order_trans_id: orderTransId,
            },
          ],
        }),
      });

      if (!response.ok) {
        throw new Error(`HTTP error! Status: ${response.status}`);
      }

      const result = await response.json();
      if (result?.data?.data) {
        setItemDetails(result.data.data);
      } else {
        console.error('Unexpected item details structure:', result);
      }
    } catch (error) {
      console.error('Failed to fetch item details:', error);
    }
  };

  const handleRowClick = (order) => {
    setSelectedOrder(order);
    fetchOrderTransactionListItem(order.order_trans_id);
  };

  const handleOpenModal = (item = null) => {
    setSelectedItem(item);
    setModalOpen(true);
  };

  const handleCloseModal = () => {
    setModalOpen(false);
    setSelectedItem(null);
  };

  const handleConfirmVoid = () => {
    console.log(`Void action for ${selectedItem ? 'item' : 'bill'}`);
    handleCloseModal();
  };

  const calculateTotalAmount = () => {
    // const totalAmount = itemDetails.reduce((total, item) => total + item.amt, 0);
    const taxSummary = {};

    const totalAmount = itemDetails.reduce((total, item) => {
      // Aggregate taxes
      if (item.tax_code1) {
        taxSummary[item.tax_code1] = (taxSummary[item.tax_code1] || 0) + parseFloat(item.tax_amt1_calc);
      }
      if (item.tax_code2) {
        taxSummary[item.tax_code2] = (taxSummary[item.tax_code2] || 0) + parseFloat(item.tax_amt2_calc);
      }
      return total + parseFloat(item.amt);
    }, 0);
    // const serviceCharge = totalAmount * 0.06;
    // const tax = (totalAmount + serviceCharge) * 0.08;
    const discountAmount = totalAmount * (discount / 100);
    // const total = totalAmount + serviceCharge + tax - discountAmount;
    // const total = totalAmount + serviceCharge - discountAmount;
    const total = totalAmount - discountAmount;

    return {
      totalAmount: totalAmount,
      // serviceCharge: serviceCharge,
      // tax: tax,
      discountAmount: discountAmount,
      total: total,
      taxSummary,
    };
  };
  // const { totalAmount, serviceCharge, discountAmount, total, taxSummary } = calculateTotalAmount();

  const { totalAmount,discountAmount, total, taxSummary } = calculateTotalAmount();

  return (
    <>
      <Breadcrumb>
        <Typography component={Link} to="/" variant="subtitle2" color="inherit">
          Home
        </Typography>
        <Typography variant="subtitle2" color="primary">
          Payment and Billings
        </Typography>
      </Breadcrumb>

      <Grid container spacing={gridSpacing}>
        <Grid item xs={12} md={6}>
          <Card>
            <CardContent>
              <Typography variant="h6">Orders</Typography>
              <Divider sx={{ my: 1 }} />
              <TableContainer>
                <Table>
                  <TableHead>
                    <TableRow>
                      <TableCell>Order ID</TableCell>
                      <TableCell align="center">Table No</TableCell>
                      <TableCell align="center">Status</TableCell>
                      <TableCell align="center">Amount</TableCell>
                    </TableRow>
                  </TableHead>
                  <TableBody>
                    {tableData.map((order) => (
                      <TableRow
                        key={order.order_trans_id}
                        hover
                        onClick={() => handleRowClick(order)}
                        style={{ cursor: 'pointer' }}
                      >
                        <TableCell>{order.order_trans_id}</TableCell>
                        <TableCell align="center">{order.table_no}</TableCell>
                        <TableCell align="center">{order.tr_status}</TableCell>
                        <TableCell align="center">RM {order.amt}</TableCell>
                      </TableRow>
                    ))}
                  </TableBody>
                </Table>
              </TableContainer>
            </CardContent>
          </Card>
        </Grid>

        <Grid item xs={12} md={6}>
          {selectedOrder && (
            <Card>
              <CardContent>
                <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                  <Typography variant="h6">Order Details</Typography>
                  <Box sx={{ display: 'flex', gap: 2 }}>
                    <Button variant="contained" color="error" onClick={() => handleOpenModal()}>
                      Void Bill
                    </Button>
                  </Box>
                </Box>
                <Divider sx={{ my: 1 }} />
                <TableContainer>
                  <Table>
                    <TableHead>
                      <TableRow>
                        <TableCell>Product</TableCell>
                        <TableCell align="center">Qty</TableCell>
                        <TableCell align="center">Price</TableCell>
                        <TableCell align="center">Amount</TableCell>
                        <TableCell align="center">Action</TableCell>
                      </TableRow>
                    </TableHead>
                    <TableBody>
                      {itemDetails.map((item) => (
                        <TableRow key={item.order_trans_item_line_id}>
                          <TableCell>{item.product_desc}</TableCell>
                          <TableCell align="center">{item.qty}</TableCell>
                          <TableCell align="center">RM {item.sell_price}</TableCell>
                          <TableCell align="center">RM {item.amt}</TableCell>
                          <TableCell align="center">
                            <IconButton color="error" onClick={() => handleOpenModal(item)}>
                              <DeleteIcon />
                            </IconButton>
                          </TableCell>
                        </TableRow>
                      ))}
                    </TableBody>
                  </Table>
                </TableContainer>
                <Box sx={{ my: 2 }}>
                  {/* <Typography align="right">Service Charge (6%): RM {calculateTotalAmount().serviceCharge}</Typography>
                  <Typography align="right">Tax SST (8%): RM {calculateTotalAmount().tax}</Typography> */}
                  {/* <Typography align="right">Service Charge (6%): RM {serviceCharge}</Typography> */}
                  {Object.entries(taxSummary).map(([code, amount]) => (
                    <Typography key={code} align="right">{code}: RM {amount.toFixed(2)}</Typography>
                  ))}
                  <TextField
                    label="Discount (%)"
                    type="number"
                    value={discount}
                    onChange={(e) => setDiscount(parseFloat(e.target.value) || '')}
                    fullWidth
                  />
                  {/* <Typography align="right">Discount Amount: RM {calculateTotalAmount().discountAmount}</Typography>
                  <Typography align="right">Total Amount: RM {calculateTotalAmount().total}</Typography> */}
                  <Typography align="right">Discount Amount: RM {discountAmount.toFixed(2)}</Typography>
                  <Typography align="right">Total Amount: RM {total.toFixed(2)}</Typography>
                </Box>
                <Button variant="contained" fullWidth>PAY BILL</Button>
              </CardContent>
            </Card>
          )}
        </Grid>
      </Grid>

      <Modal open={modalOpen} onClose={handleCloseModal}>
        <Box
          sx={{
            position: 'absolute',
            top: '50%',
            left: '50%',
            transform: 'translate(-50%, -50%)',
            width: 400,
            bgcolor: 'background.paper',
            boxShadow: 24,
            borderRadius: 3,
            p: 4,
          }}
        >
          <Typography variant="h5">Confirm Void {selectedItem ? 'Item' : 'Bill'}</Typography>
          <Typography sx={{ mt: 2 }}>Are you sure you want to void this {selectedItem ? 'item' : 'bill'}?</Typography>
          <Box sx={{ mt: 3, display: 'flex', justifyContent: 'flex-end', gap: 2 }}>
            <Button variant="outlined" onClick={handleCloseModal}>Cancel</Button>
            <Button variant="contained" color="error" onClick={handleConfirmVoid}>Confirm</Button>
          </Box>
        </Box>
      </Modal>
    </>
  );
};

export default PaymentBillings;
