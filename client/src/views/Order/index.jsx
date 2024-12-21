import React, { useState, useEffect } from 'react';
import { Link, useLocation } from 'react-router-dom';

// material-ui
import { Card, CardContent, Grid, Typography, Button, Divider, Box, Tab, IconButton, MenuItem, FormControl, Popover, Select, Radio, RadioGroup, FormControlLabel, Checkbox, FormGroup } from '@mui/material';
import { TabContext, TabList } from '@mui/lab';
import AddIcon from '@mui/icons-material/Add';
import RemoveIcon from '@mui/icons-material/Remove';
import CloseIcon from '@mui/icons-material/Close';

// project import
import Breadcrumb from 'component/Breadcrumb';
import { gridSpacing } from 'config.js';

const Order = () => {
  const [orderedItems, setOrderedItems] = useState([]);
  const [selectedModifiers, setSelectedModifiers] = useState({});
  const [modifierAnchorEl, setModifierAnchorEl] = useState(null);
  const [currentItem, setCurrentItem] = useState(null);

  // Function to add an item to the order by its id
  const addToOrder = (item, modifiers) => {
    setOrderedItems(prevItems => {
      const existingItem = prevItems.find(orderedItem => orderedItem.product_id === item.product_id);
      if (existingItem) {
        return prevItems.map(orderedItem =>
          orderedItem.product_id === item.product_id
            ? { ...orderedItem, quantity: orderedItem.quantity + 1, modifiers }
            : orderedItem
        );
      }
      return [...prevItems, { ...item, quantity: 1, modifiers }];
    });
  };

  // Function to remove an item from the order if the quantity is zero
  const handleRemoveItem = (product_id) => {
    setOrderedItems(prevItems => prevItems.filter(item => item.product_id !== product_id));
  };

  // Function to update the quantity of an item
  const updateQuantity = (product_id, newQuantity) => {
    setOrderedItems(prevItems =>
      prevItems.map(item =>
        item.product_id === product_id ? { ...item, quantity: newQuantity } : item
      )
    );
  };

  const getTotalPrice = () => {
    return orderedItems.reduce((total, item) => total + item.cost * item.quantity, 0);
  };

  const handleModifierChange = (modifierGroupName, optionId, isChecked) => {
    setSelectedModifiers(prevModifiers => {
      const updatedModifiers = { ...prevModifiers };
      if (!updatedModifiers[currentItem.product_id]) {
        updatedModifiers[currentItem.product_id] = {};
      }
      if (!updatedModifiers[currentItem.product_id][modifierGroupName]) {
        updatedModifiers[currentItem.product_id][modifierGroupName] = [];
      }

      if (isChecked) {
        updatedModifiers[currentItem.product_id][modifierGroupName].push(optionId);
      } else {
        updatedModifiers[currentItem.product_id][modifierGroupName] = updatedModifiers[currentItem.product_id][modifierGroupName].filter(id => id !== optionId);
      }

      return updatedModifiers;
    });
  };

  const handlePlaceOrder = () => {
    alert('Order placed successfully!');
    window.location.reload();
  };

  const handleOpenModifiers = (event, item) => {
    if (item.modifiers && item.modifiers.length > 0) {
      setModifierAnchorEl(event.currentTarget);
      setCurrentItem(item);

      // Auto-fill default modifiers
      const defaultModifiers = {};
      item.modifiers.forEach((modifier) => {
        const defaultOptions = modifier.options.filter(option => option.is_default === 1);
        if (defaultOptions.length > 0) {
          defaultModifiers[modifier.modifier_group_name] = defaultOptions.map(option => option.modifier_option_id);
        }
      });

      setSelectedModifiers(prevModifiers => ({
        ...prevModifiers,
        [item.product_id]: defaultModifiers,
      }));
    } else {
      addToOrder(item, {});
    }
  };

  const handleCloseModifiers = () => {
    setModifierAnchorEl(null);
  };

  const handleAddWithModifiers = () => {
    if (currentItem) {
      addToOrder(currentItem, selectedModifiers[currentItem.product_id] || {});
      setCurrentItem(null);
      setModifierAnchorEl(null);
    }
  };

  const open = Boolean(modifierAnchorEl);

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
          Order Page
        </Typography>
      </Breadcrumb>

      <Grid container spacing={gridSpacing} padding="0px">
        {/* Grid for Menu Category */}
        <Grid item xl={9} lg={8} sm={8} xs={12}>
          <Card
            sx={{
              width: '100%',
              margin: 'auto',
              display: 'flex',
              flexDirection: 'column',
            }}
          >
            <MenuCategory handleOpenModifiers={handleOpenModifiers} />
          </Card>
        </Grid>

        <Grid item xl={3} lg={4} sm={4} md={4} xs={12}>
          <Card
            sx={{
              width: '100%',
              display: 'flex',
              flexDirection: 'column',
              justifyContent: 'space-between', // Ensure space between content and bottom
              overflow: 'hidden',
              height: {
                xs: '440px',
                sm: '490px',
                md: '600px',
                lg: '640px',
                xl: '700px',
                xxl: '1095px'
              },
            }}
          >
            <OrderDetails />

            {/* Ordered items scrollable section */}
            <Box sx={{ flexGrow: 1, overflowY: 'auto', padding: '0px' }}>
              {orderedItems.map((item) => (
                <MenuOrdered
                  key={item.product_id}
                  product_id={item.product_id}
                  product_desc={item.product_desc}
                  sell_price={item.cost}
                  quantity={item.quantity}
                  onRemoveItem={handleRemoveItem}
                  updateQuantity={updateQuantity}
                  modifiers={item.modifiers}
                />
              ))}
            </Box>

            {/* Divider */}
            <Divider />

            {/* Fixed total price and place order button at the bottom */}
            <Box>
              {/* Total Price */}
              <CardContent>
                <Typography variant="h6" align="right">
                  Total: RM {getTotalPrice().toFixed(2)}
                </Typography>
              </CardContent>

              {/* Place Order Button */}
              <CardContent>
                <Button
                  variant="contained"
                  fullWidth
                  onClick={handlePlaceOrder}
                  disabled={orderedItems.length === 0} // Disable if no items in order
                  sx={{
                    backgroundColor: "#FFB000",
                    color: "#000",
                    '&:hover': {
                      backgroundColor: "#F7E6C4",
                    }
                  }}
                >
                  Place Order
                </Button>
              </CardContent>
            </Box>
          </Card>
        </Grid>
      </Grid>

      {/* Popover for Modifier Selection */}
      {currentItem && currentItem.modifiers && (
        <Popover
          open={open}
          anchorEl={modifierAnchorEl}
          onClose={handleCloseModifiers}
          anchorOrigin={{
            vertical: 'bottom',
            horizontal: 'center',
          }}
          transformOrigin={{
            vertical: 'top',
            horizontal: 'center',
          }}
        >
          <Box p={2} width={300}>
            <Box display="flex" justifyContent="space-between" alignItems="center" mb={2}>
              <Typography variant="h6" color="#33372C">
                Select Modifiers
              </Typography>
              <IconButton size="small" onClick={handleCloseModifiers}>
                <CloseIcon />
              </IconButton>
            </Box>
            {currentItem.modifiers.map((modifier) => (
              <Box key={modifier.modifier_group_name} my={2}>
                <Typography variant="subtitle1">{modifier.modifier_group_name}</Typography>
                {modifier.sing_c === 1 ? (
                  <RadioGroup
                    value={selectedModifiers[currentItem.product_id]?.[modifier.modifier_group_name]?.[0] || ''}
                    onChange={(e) => handleModifierChange(modifier.modifier_group_name, e.target.value, true)}
                  >
                    {modifier.options.map((option) => (
                      <FormControlLabel
                        key={option.modifier_option_id}
                        value={option.modifier_option_id}
                        control={<Radio />}
                        label={`${option.modifier_option_name} (+RM ${option.addon_amt.toFixed(2)})`}
                      />
                    ))}
                  </RadioGroup>
                ) : (
                  <FormGroup>
                    {modifier.options.map((option) => (
                      <FormControlLabel
                        key={option.modifier_option_id}
                        control={
                          <Checkbox
                            checked={selectedModifiers[currentItem.product_id]?.[modifier.modifier_group_name]?.includes(option.modifier_option_id) || false}
                            onChange={(e) => handleModifierChange(modifier.modifier_group_name, option.modifier_option_id, e.target.checked)}
                          />
                        }
                        label={`${option.modifier_option_name} (+RM ${option.addon_amt.toFixed(2)})`}
                      />
                    ))}
                  </FormGroup>
                )}
              </Box>
            ))}
            <Button
              variant="contained"
              fullWidth
              onClick={handleAddWithModifiers}
              sx={{
                mt: 2,
                backgroundColor: "#FFB000",
                color: "#000",
                '&:hover': {
                  backgroundColor: "#F7E6C4",
                },
              }}
            >
              Add
            </Button>
          </Box>
        </Popover>
      )}
    </>
  );
};

const MenuCategory = ({ handleOpenModifiers }) => {
  const [value, setValue] = useState('All');
  const [items, setItems] = useState([]); // Initialize items with an empty array
  const [category, setCategory] = useState([]); // Initialize category with an empty array

  React.useEffect(() => {
    const fetchCategories = async () => {
      try {
        const response = await fetch('http://localhost:38998/prodCat/l', {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
          },
          body: JSON.stringify({
            code: 'prod-category',
            axn: 'l',
            data: [
              {
                current_uid: 'tester',
                is_in_use: -1,
              },
            ],
          }),
        });

        if (!response.ok) {
          throw new Error(`HTTP error! Status: ${response.status}`);
        }

        const result = await response.json();
        if (result && result.data && Array.isArray(result.data.data)) {
          setCategory(result.data.data); // Update category state with fetched data
        } else {
          console.error('Unexpected category structure:', result);
        }
      } catch (error) {
        console.error('Failed to fetch categories:', error);
      }
    };

    const fetchItems = async () => {
      try {
        const response = await fetch('http://localhost:38998/ord/pl', {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
          },
          body: JSON.stringify({
            code: 'app-order-trans',
            axn: 'pl',
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
          setItems(result.data.data); // Update items state with fetched data
        } else {
          console.error('Unexpected items structure:', result);
        }
      } catch (error) {
        console.error('Failed to fetch items:', error);
      }
    };

    fetchCategories();
    fetchItems();
  }, []);

  const handleChange = (event, newValue) => {
    setValue(newValue);
  };

  // Function to filter and render MenuCards based on the selected category
  const renderMenuCards = () => {
    const filteredItems = value === 'All' ? items : items.filter(item => item.category_id === category.find(cat => cat.category_desc === value)?.category_id);

    return (
      <Box 
        display="grid"
        gridTemplateColumns="repeat(auto-fill, minmax(200px, 1fr))"
        gap="10px"
      >
        {filteredItems.map((item) => (
          <Box
            key={item.product_id}
            backgroundColor={"#F5F5DC"}
            display="flex"
            flexDirection="column"
            sx={{
              '&:hover': {
                border: "2px solid #557C56",
              }
            }}
            onClick={(e) => handleOpenModifiers(e, item)} // Call handleOpenModifiers when clicked
          >
            <Box margin={4}>
              <Typography variant="h7" color={"#557C56"}>
                {item.product_desc}
              </Typography>
              <Typography variant="h6" color={"#7D7C7C"} fontWeight="bold">
                RM {item.cost}
              </Typography>
            </Box>
          </Box>
        ))}
      </Box>
    );
  };

  return (
    <Box>
      <Box sx={{ width: '100%', typography: 'body1' }}>
        <TabContext value={value}>
          <Box sx={{ borderBottom: 1, borderColor: 'divider' }}>
            <TabList
              onChange={handleChange}
              aria-label="menu categories"
              variant="scrollable" // Enable scrolling for tabs
              scrollButtons="auto" // Show scroll buttons automatically when needed
              allowScrollButtonsMobile // Allows scroll buttons on mobile devices
            >            
              <Tab label="All" value="All" />
              {category.map((cat) => (
                <Tab key={cat.category_id} label={cat.category_desc} value={cat.category_desc} />
              ))}
            </TabList>
          </Box>

          {/* Conditionally render MenuCards based on the selected category */}
          <Box 
            sx={{
              p: "10px",
              overflow: 'auto',  // Enable scroll
              height: {
                xs: '400px', // Adjust for small screens
                sm: '440px', // Adjust for screens >= 768px
                md: '580px', // Adjust for screens >= 1024px
                lg: '590px', // Adjust for screens >= 1266px
                xl: '700px', // Adjust for screens >= 1440px
                xxl: '1050px'
              },
              "::-webkit-scrollbar": {
                display: "none", // Hides the scrollbar in Chrome, Safari, and other WebKit browsers
              },
              scrollbarWidth: "none", // Hides the scrollbar in Firefox
            }}
          >
            {renderMenuCards()}
          </Box>
        </TabContext>
      </Box>
    </Box>
  );
};



const MenuOrdered = ({ product_id, product_desc, sell_price, quantity, onRemoveItem, updateQuantity, modifiers }) => {
  const handleAdd = () => {
    updateQuantity(product_id, quantity + 1);
  };

  const handleRemove = () => {
    if (quantity > 1) {
      updateQuantity(product_id, quantity - 1);
    } else {
      onRemoveItem(product_id); // Call the function to remove the item if quantity is 0
    }
  };

  const totalPrice = sell_price * quantity;

  return (
    <Box 
      mx="12px"
      my="4px"
      borderRadius="10px"
      sx={{
        backgroundColor: "#F5F5F5",
        boxShadow: "0px 2px 5px rgba(0, 0, 0, 0.20)",
        position: 'relative'
      }}
    >
      <Box
        mx="20px"
        my="10px"
        display="flex"
        alignItems="center"
        justifyContent="space-between"
      >
        <Box ml="10px">
          <Typography variant="h6" color="#33372C">
            {product_desc}
          </Typography>
          <Typography variant="subtitle2" color="grey">
            RM {totalPrice.toFixed(2)}
          </Typography>
        </Box>

        <Box display="flex" alignItems="center">
          <IconButton 
            size="small"
            onClick={handleRemove}
            sx={{ width: "20px", height: "20px", border: "1px solid #ccc", borderRadius: "25px" }} 
          >
            <RemoveIcon fontSize="small" />
          </IconButton>

          <Typography variant="h6" mx="15px">
            {quantity}
          </Typography>

          <IconButton 
            size="small"
            onClick={handleAdd}
            sx={{ width: "20px", height: "20px", border: "1px solid #ccc", borderRadius: "25px" }} 
          >
            <AddIcon fontSize="small" />
          </IconButton>
        </Box>
      </Box>
    </Box>
  );
};

const OrderDetails = () => {
  const location = useLocation();
  const [table, setTable] = useState(location.state?.table || 'Select Table');
  const [dineOption, setDineOption] = useState(location.state?.dineOption || 'Order Type');
  const [tableOptions, setTableOptions] = useState([]);

  useEffect(() => {
    const fetchData = async () => {
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
          const availableTables = result.data.data.filter((t) => t.is_occ === 0);
          setTableOptions(availableTables);
        } else {
          console.error('Unexpected response structure:', result);
        }
      } catch (error) {
        console.error('Failed to fetch tables:', error);
      }
    };

    fetchData();
  }, []);

  const handleTableChange = (e) => {
    setTable(e.target.value);
  };

  const handleDineOptionChange = (e) => {
    setDineOption(e.target.value);
    if (e.target.value !== "Dine In") {
      setTable(''); // Reset table selection if not Dine In
    }
  };

  return (
    <Box
      sx={{
        padding: 2,
        borderBottom: '1px solid #ccc',
        backgroundColor: 'transparent',
        margin: '10px',
      }}
    >
      <Typography
        variant="h4"
        fontWeight="bold"
        color="#33372C"
        gutterBottom
        sx={{ textAlign: 'center' }}
      >
        Order Details
      </Typography>

      <Box sx={{ display: 'flex', gap: "5px" }}>
        <FormControl fullWidth sx={{ borderRadius: '24px', flex: 1 }}>
          <Select
            value={dineOption}
            onChange={handleDineOptionChange}
            sx={{
              borderRadius: '24px',
              backgroundColor: '#f5f5f5',
              width: '100%',
              height: '35px',
            }}
          >
            <MenuItem value="Order Type" disabled>Order Type</MenuItem>
            <MenuItem value="Dine In">Dine In</MenuItem>
            <MenuItem value="Room Service">Room Service</MenuItem>
            <MenuItem value="Take Away">Take Away</MenuItem>
          </Select>
        </FormControl>
        {dineOption === "Dine In" && (
          <FormControl fullWidth sx={{ borderRadius: "24px", flex: 1 }}>
            <Select
              value={table}
              onChange={handleTableChange}
              sx={{
                borderRadius: '24px',
                backgroundColor: '#f5f5f5',
                width: '100%',
                height: '35px',
              }}
            >
              <MenuItem value="Select Table" disabled>Select Table</MenuItem>
              {tableOptions.map((row) => (
                <MenuItem key={row.order_trans_table_id} value={row.order_trans_table_id}>
                  {row.table_desc}
                </MenuItem>
              ))}
            </Select>
          </FormControl>
        )}
      </Box>
    </Box>
  );
};


export default Order;
