# Admin Panel - Implementation Plan

## 🎯 **Implementation Overview**

This plan outlines the step-by-step development of the Next.js admin panel, broken into manageable phases with clear deliverables and timelines.

## 📅 **Phase 1: Foundation Setup (Week 1-2)**

### **Week 1: Project Initialization**

#### **Day 1-2: Project Setup**
```bash
# Create Next.js Application
npx create-next-app@latest pend-admin-panel --typescript --tailwind --eslint --app

# Install Core Dependencies
npm install @tanstack/react-query zustand react-hook-form
npm install @hookform/resolvers zod date-fns
npm install lucide-react @radix-ui/react-icons

# Install Shadcn/UI
npx shadcn-ui@latest init
npx shadcn-ui@latest add button card input label
npx shadcn-ui@latest add table badge dropdown-menu
npx shadcn-ui@latest add dialog sheet toast
```

#### **Day 3-4: Core Architecture Setup**
```typescript
// File Structure Creation
src/
├── app/
│   ├── (auth)/
│   │   ├── login/
│   │   │   └── page.tsx
│   │   └── layout.tsx
│   ├── (dashboard)/
│   │   ├── dashboard/
│   │   │   └── page.tsx
│   │   ├── assets/
│   │   │   └── page.tsx
│   │   ├── kyc/
│   │   │   └── page.tsx
│   │   ├── users/
│   │   │   └── page.tsx
│   │   └── layout.tsx
│   ├── api/
│   │   └── auth/
│   │       └── route.ts
│   ├── globals.css
│   ├── layout.tsx
│   └── page.tsx
├── components/
│   ├── ui/ (shadcn components)
│   ├── layout/
│   │   ├── sidebar.tsx
│   │   ├── header.tsx
│   │   └── navigation.tsx
│   └── forms/
├── lib/
│   ├── api.ts
│   ├── auth.ts
│   ├── utils.ts
│   └── validations.ts
├── hooks/
│   ├── use-api.ts
│   └── use-auth.ts
├── types/
│   ├── api.ts
│   ├── auth.ts
│   └── admin.ts
└── stores/
    ├── auth.ts
    └── admin.ts
```

#### **Day 5: Authentication System**
```typescript
// lib/auth.ts - Authentication utilities
export interface AdminUser {
  id: string;
  email: string;
  name: string;
  role: 'super_admin' | 'asset_manager' | 'kyc_verifier' | 'auditor' | 'viewer';
  permissions: string[];
  blockchainAddress?: string;
}

export const authApi = {
  login: async (email: string, password: string) => Promise<LoginResponse>,
  logout: async () => Promise<void>,
  refreshToken: async () => Promise<TokenResponse>,
  getCurrentUser: async () => Promise<AdminUser>
};

// stores/auth.ts - Zustand auth store
interface AuthState {
  user: AdminUser | null;
  token: string | null;
  isAuthenticated: boolean;
  login: (email: string, password: string) => Promise<void>;
  logout: () => void;
  refreshToken: () => Promise<void>;
}
```

### **Week 2: Core Layout & Navigation**

#### **Day 1-2: Layout Components**
```typescript
// components/layout/sidebar.tsx
export function Sidebar() {
  const menuItems = [
    { name: 'Dashboard', href: '/dashboard', icon: LayoutDashboard },
    { name: 'Assets', href: '/assets', icon: Building2 },
    { name: 'KYC', href: '/kyc', icon: FileCheck },
    { name: 'Users', href: '/users', icon: Users },
    { name: 'Analytics', href: '/analytics', icon: BarChart3 },
    { name: 'Settings', href: '/settings', icon: Settings }
  ];
  
  return (
    <div className="w-64 bg-white border-r">
      {/* Navigation implementation */}
    </div>
  );
}

// components/layout/header.tsx
export function Header() {
  return (
    <header className="h-16 border-b bg-white flex items-center px-6">
      {/* Header with user menu, notifications, etc. */}
    </header>
  );
}
```

#### **Day 3-4: API Integration Setup**
```typescript
// lib/api.ts - API client
export class AdminApiClient {
  private baseUrl: string;
  private token: string | null = null;

  constructor(baseUrl: string) {
    this.baseUrl = baseUrl;
  }

  setToken(token: string) {
    this.token = token;
  }

  private async request<T>(endpoint: string, options?: RequestInit): Promise<T> {
    const url = `${this.baseUrl}${endpoint}`;
    const headers = {
      'Content-Type': 'application/json',
      ...(this.token && { Authorization: `Bearer ${this.token}` }),
      ...options?.headers
    };

    const response = await fetch(url, {
      ...options,
      headers
    });

    if (!response.ok) {
      throw new Error(`API Error: ${response.status}`);
    }

    return response.json();
  }

  // Asset Management
  async getAssets(filters?: AssetFilters) {
    return this.request<Asset[]>('/api/admin/opportunities', {
      method: 'GET'
    });
  }

  // KYC Management
  async getKycApplications() {
    return this.request<KycApplication[]>('/api/kyc/admin/pending');
  }

  // User Management
  async getUsers(filters?: UserFilters) {
    return this.request<User[]>('/api/wallet/wallets');
  }
}
```

#### **Day 5: Dashboard Overview Page**
```typescript
// app/(dashboard)/dashboard/page.tsx
export default function DashboardPage() {
  const { data: stats } = useQuery({
    queryKey: ['dashboard-stats'],
    queryFn: () => api.getDashboardStats()
  });

  return (
    <div className="p-6">
      <h1 className="text-3xl font-bold mb-6">Admin Dashboard</h1>
      
      {/* KPI Cards */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
        <StatsCard
          title="Total Users"
          value={stats?.totalUsers || 0}
          change="+12%"
          icon={Users}
        />
        <StatsCard
          title="Active Assets"
          value={stats?.activeAssets || 0}
          change="+8%"
          icon={Building2}
        />
        <StatsCard
          title="Pending KYC"
          value={stats?.pendingKyc || 0}
          change="-5%"
          icon={FileCheck}
        />
        <StatsCard
          title="Total AUM"
          value={formatCurrency(stats?.totalAum || 0)}
          change="+15%"
          icon={DollarSign}
        />
      </div>

      {/* Charts and Recent Activity */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        <Card>
          <CardHeader>
            <CardTitle>Recent Activity</CardTitle>
          </CardHeader>
          <CardContent>
            <RecentActivityList />
          </CardContent>
        </Card>
        
        <Card>
          <CardHeader>
            <CardTitle>Investment Trends</CardTitle>
          </CardHeader>
          <CardContent>
            <InvestmentTrendsChart />
          </CardContent>
        </Card>
      </div>
    </div>
  );
}
```

## 📅 **Phase 2: Core Features (Week 3-4)**

### **Week 3: Asset Management**

#### **Day 1-2: Assets List View**
```typescript
// app/(dashboard)/assets/page.tsx
export default function AssetsPage() {
  const [filters, setFilters] = useState<AssetFilters>({});
  const [pagination, setPagination] = useState({ page: 1, limit: 25 });

  const { data: assets, isLoading } = useQuery({
    queryKey: ['assets', filters, pagination],
    queryFn: () => api.getAssets({ ...filters, ...pagination })
  });

  return (
    <div className="p-6">
      <div className="flex justify-between items-center mb-6">
        <h1 className="text-3xl font-bold">Asset Management</h1>
        <Button>
          <Plus className="w-4 h-4 mr-2" />
          Create Asset
        </Button>
      </div>

      {/* Filters */}
      <Card className="mb-6">
        <CardContent className="pt-6">
          <AssetFilters 
            filters={filters} 
            onFiltersChange={setFilters} 
          />
        </CardContent>
      </Card>

      {/* Assets Table */}
      <Card>
        <CardContent>
          <AssetsDataTable
            data={assets?.data || []}
            loading={isLoading}
            pagination={assets?.pagination}
            onPaginationChange={setPagination}
          />
        </CardContent>
      </Card>
    </div>
  );
}

// components/assets/assets-data-table.tsx
export function AssetsDataTable({ data, loading, pagination, onPaginationChange }) {
  const columns = [
    {
      accessorKey: 'title',
      header: 'Title',
      cell: ({ row }) => (
        <div className="flex items-center">
          <img 
            src={row.original.image} 
            alt={row.original.title}
            className="w-8 h-8 rounded mr-3"
          />
          <div>
            <div className="font-medium">{row.original.title}</div>
            <div className="text-sm text-gray-500">{row.original.category}</div>
          </div>
        </div>
      )
    },
    {
      accessorKey: 'type',
      header: 'Type',
      cell: ({ row }) => (
        <Badge variant={row.original.type === 'investment' ? 'default' : 'secondary'}>
          {row.original.type}
        </Badge>
      )
    },
    {
      accessorKey: 'status',
      header: 'Status',
      cell: ({ row }) => <StatusBadge status={row.original.status} />
    },
    {
      accessorKey: 'totalInvested',
      header: 'Total Invested',
      cell: ({ row }) => formatCurrency(row.original.totalInvested)
    },
    {
      accessorKey: 'investorCount',
      header: 'Investors',
      cell: ({ row }) => row.original.investorCount
    },
    {
      accessorKey: 'createdAt',
      header: 'Created',
      cell: ({ row }) => formatDate(row.original.createdAt)
    },
    {
      id: 'actions',
      header: 'Actions',
      cell: ({ row }) => <AssetActions asset={row.original} />
    }
  ];

  return (
    <DataTable
      columns={columns}
      data={data}
      loading={loading}
      pagination={pagination}
      onPaginationChange={onPaginationChange}
    />
  );
}
```

#### **Day 3-4: Asset Creation Form**
```typescript
// components/assets/create-asset-form.tsx
export function CreateAssetForm() {
  const [step, setStep] = useState(1);
  const form = useForm<AssetFormData>({
    resolver: zodResolver(assetFormSchema),
    defaultValues: INITIAL_ASSET_FORM_DATA
  });

  const { mutate: createAsset, isPending } = useMutation({
    mutationFn: api.createAsset,
    onSuccess: () => {
      toast({ title: 'Asset created successfully' });
      // Navigate to asset details
    }
  });

  const onSubmit = (data: AssetFormData) => {
    createAsset(data);
  };

  return (
    <Card className="max-w-4xl mx-auto">
      <CardHeader>
        <CardTitle>Create New Asset</CardTitle>
        <div className="flex items-center space-x-2">
          {[1, 2, 3, 4, 5].map((stepNumber) => (
            <div
              key={stepNumber}
              className={`w-8 h-8 rounded-full flex items-center justify-center text-sm ${
                step >= stepNumber
                  ? 'bg-blue-600 text-white'
                  : 'bg-gray-200 text-gray-600'
              }`}
            >
              {stepNumber}
            </div>
          ))}
        </div>
      </CardHeader>

      <Form {...form}>
        <form onSubmit={form.handleSubmit(onSubmit)}>
          <CardContent>
            {step === 1 && <BasicInformationStep form={form} />}
            {step === 2 && <InvestmentDetailsStep form={form} />}
            {step === 3 && <LegalComplianceStep form={form} />}
            {step === 4 && <AssetManagerStep form={form} />}
            {step === 5 && <ReviewDeployStep form={form} />}
          </CardContent>

          <CardFooter className="flex justify-between">
            <Button
              type="button"
              variant="outline"
              onClick={() => setStep(step - 1)}
              disabled={step === 1}
            >
              Previous
            </Button>
            
            {step < 5 ? (
              <Button
                type="button"
                onClick={() => setStep(step + 1)}
              >
                Next
              </Button>
            ) : (
              <Button type="submit" disabled={isPending}>
                {isPending ? 'Deploying...' : 'Deploy Asset'}
              </Button>
            )}
          </CardFooter>
        </form>
      </Form>
    </Card>
  );
}
```

#### **Day 5: Asset Analytics Dashboard**
```typescript
// components/assets/asset-analytics.tsx
export function AssetAnalytics({ assetId }: { assetId: string }) {
  const { data: analytics } = useQuery({
    queryKey: ['asset-analytics', assetId],
    queryFn: () => api.getAssetAnalytics(assetId)
  });

  return (
    <div className="space-y-6">
      {/* Key Metrics */}
      <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
        <MetricCard
          title="Total Invested"
          value={formatCurrency(analytics?.totalInvested || 0)}
          change={analytics?.investmentChange}
        />
        <MetricCard
          title="Investor Count"
          value={analytics?.investorCount || 0}
          change={analytics?.investorChange}
        />
        <MetricCard
          title="Current ROI"
          value={`${analytics?.currentROI || 0}%`}
          change={analytics?.roiChange}
        />
      </div>

      {/* Charts */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        <Card>
          <CardHeader>
            <CardTitle>Investment Flow</CardTitle>
          </CardHeader>
          <CardContent>
            <InvestmentFlowChart data={analytics?.investmentFlow} />
          </CardContent>
        </Card>

        <Card>
          <CardHeader>
            <CardTitle>Investor Demographics</CardTitle>
          </CardHeader>
          <CardContent>
            <InvestorDemographicsChart data={analytics?.demographics} />
          </CardContent>
        </Card>
      </div>

      {/* Recent Investments */}
      <Card>
        <CardHeader>
          <CardTitle>Recent Investments</CardTitle>
        </CardHeader>
        <CardContent>
          <RecentInvestmentsTable investments={analytics?.recentInvestments} />
        </CardContent>
      </Card>
    </div>
  );
}
```

### **Week 4: KYC Management**

#### **Day 1-2: KYC Applications List**
```typescript
// app/(dashboard)/kyc/page.tsx
export default function KycPage() {
  const [statusFilter, setStatusFilter] = useState<KycStatus>('pending_review');
  
  const { data: applications, isLoading } = useQuery({
    queryKey: ['kyc-applications', statusFilter],
    queryFn: () => api.getKycApplications(statusFilter)
  });

  const { data: stats } = useQuery({
    queryKey: ['kyc-stats'],
    queryFn: () => api.getKycStats()
  });

  return (
    <div className="p-6">
      <div className="flex justify-between items-center mb-6">
        <h1 className="text-3xl font-bold">KYC Verification</h1>
        <div className="flex space-x-2">
          <Button variant="outline">Export Report</Button>
          <Button variant="outline">Bulk Actions</Button>
        </div>
      </div>

      {/* Stats Cards */}
      <div className="grid grid-cols-1 md:grid-cols-4 gap-4 mb-6">
        <StatsCard
          title="Pending Review"
          value={stats?.pending || 0}
          icon={Clock}
          color="orange"
        />
        <StatsCard
          title="Verified"
          value={stats?.verified || 0}
          icon={CheckCircle}
          color="green"
        />
        <StatsCard
          title="Rejected"
          value={stats?.rejected || 0}
          icon={XCircle}
          color="red"
        />
        <StatsCard
          title="Total Applications"
          value={stats?.total || 0}
          icon={FileText}
          color="blue"
        />
      </div>

      {/* Status Filter */}
      <Card className="mb-6">
        <CardContent className="pt-6">
          <div className="flex space-x-2">
            {(['pending_review', 'verified', 'rejected'] as KycStatus[]).map((status) => (
              <Button
                key={status}
                variant={statusFilter === status ? 'default' : 'outline'}
                onClick={() => setStatusFilter(status)}
              >
                {status.replace('_', ' ')}
              </Button>
            ))}
          </div>
        </CardContent>
      </Card>

      {/* Applications Table */}
      <Card>
        <CardContent>
          <KycApplicationsTable
            applications={applications?.applications || []}
            loading={isLoading}
          />
        </CardContent>
      </Card>
    </div>
  );
}
```

#### **Day 3-4: KYC Application Review Interface**
```typescript
// components/kyc/kyc-review-modal.tsx
export function KycReviewModal({ 
  applicationId, 
  isOpen, 
  onClose 
}: {
  applicationId: string;
  isOpen: boolean;
  onClose: () => void;
}) {
  const { data: application } = useQuery({
    queryKey: ['kyc-application', applicationId],
    queryFn: () => api.getKycApplication(applicationId),
    enabled: isOpen
  });

  const { mutate: verifyApplication } = useMutation({
    mutationFn: ({ action, reason }: { action: 'approve' | 'reject'; reason?: string }) =>
      api.verifyKycApplication(applicationId, action, reason),
    onSuccess: () => {
      toast({ title: 'Application processed successfully' });
      onClose();
    }
  });

  return (
    <Dialog open={isOpen} onOpenChange={onClose}>
      <DialogContent className="max-w-6xl h-[90vh]">
        <DialogHeader>
          <DialogTitle>KYC Application Review</DialogTitle>
        </DialogHeader>

        <div className="flex-1 grid grid-cols-1 lg:grid-cols-2 gap-6 overflow-hidden">
          {/* Application Details */}
          <div className="space-y-4">
            <Card>
              <CardHeader>
                <CardTitle>Application Details</CardTitle>
              </CardHeader>
              <CardContent>
                <div className="space-y-2">
                  <div>
                    <span className="font-medium">Phone:</span> {application?.phoneNumber}
                  </div>
                  <div>
                    <span className="font-medium">Submitted:</span> {formatDate(application?.submittedAt)}
                  </div>
                  <div>
                    <span className="font-medium">Status:</span> 
                    <StatusBadge status={application?.status} />
                  </div>
                </div>
              </CardContent>
            </Card>

            {/* Document List */}
            <Card>
              <CardHeader>
                <CardTitle>Documents</CardTitle>
              </CardHeader>
              <CardContent>
                <div className="space-y-2">
                  {Object.entries(application?.documents || {}).map(([type, doc]) => (
                    <div key={type} className="flex items-center justify-between p-2 border rounded">
                      <div>
                        <div className="font-medium">{type.toUpperCase()}</div>
                        <div className="text-sm text-gray-500">{doc.originalName}</div>
                      </div>
                      <Button
                        size="sm"
                        variant="outline"
                        onClick={() => window.open(doc.downloadUrl)}
                      >
                        <Download className="w-4 h-4" />
                      </Button>
                    </div>
                  ))}
                </div>
              </CardContent>
            </Card>

            {/* Action Buttons */}
            <div className="flex space-x-2">
              <Button
                onClick={() => verifyApplication({ action: 'approve' })}
                className="flex-1 bg-green-600 hover:bg-green-700"
              >
                <Check className="w-4 h-4 mr-2" />
                Approve
              </Button>
              <Button
                onClick={() => setShowRejectModal(true)}
                variant="destructive"
                className="flex-1"
              >
                <X className="w-4 h-4 mr-2" />
                Reject
              </Button>
            </div>
          </div>

          {/* Document Viewer */}
          <div className="border rounded-lg overflow-hidden">
            <DocumentViewer applicationId={applicationId} />
          </div>
        </div>
      </DialogContent>
    </Dialog>
  );
}
```

#### **Day 5: KYC Analytics & Reporting**
```typescript
// components/kyc/kyc-analytics.tsx
export function KycAnalytics() {
  const { data: analytics } = useQuery({
    queryKey: ['kyc-analytics'],
    queryFn: () => api.getKycAnalytics()
  });

  return (
    <div className="space-y-6">
      {/* Processing Metrics */}
      <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
        <MetricCard
          title="Avg. Processing Time"
          value={`${analytics?.avgProcessingTime || 0} hours`}
          change={analytics?.processingTimeChange}
        />
        <MetricCard
          title="Approval Rate"
          value={`${analytics?.approvalRate || 0}%`}
          change={analytics?.approvalRateChange}
        />
        <MetricCard
          title="Documents Quality Score"
          value={`${analytics?.qualityScore || 0}%`}
          change={analytics?.qualityScoreChange}
        />
      </div>

      {/* Charts */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        <Card>
          <CardHeader>
            <CardTitle>Processing Volume</CardTitle>
          </CardHeader>
          <CardContent>
            <ProcessingVolumeChart data={analytics?.processingVolume} />
          </CardContent>
        </Card>

        <Card>
          <CardHeader>
            <CardTitle>Rejection Reasons</CardTitle>
          </CardHeader>
          <CardContent>
            <RejectionReasonsChart data={analytics?.rejectionReasons} />
          </CardContent>
        </Card>
      </div>

      {/* Verifier Performance */}
      <Card>
        <CardHeader>
          <CardTitle>Verifier Performance</CardTitle>
        </CardHeader>
        <CardContent>
          <VerifierPerformanceTable data={analytics?.verifierPerformance} />
        </CardContent>
      </Card>
    </div>
  );
}
```

## 📅 **Phase 3: User Management & Analytics (Week 5-6)**

### **Week 5: User Management**

#### **Day 1-2: User Directory**
```typescript
// app/(dashboard)/users/page.tsx
export default function UsersPage() {
  const [filters, setFilters] = useState<UserFilters>({});
  const [selectedUsers, setSelectedUsers] = useState<string[]>([]);

  const { data: users, isLoading } = useQuery({
    queryKey: ['users', filters],
    queryFn: () => api.getUsers(filters)
  });

  return (
    <div className="p-6">
      <div className="flex justify-between items-center mb-6">
        <h1 className="text-3xl font-bold">User Management</h1>
        <div className="flex space-x-2">
          <Button variant="outline">Export Users</Button>
          <Button variant="outline">Bulk Actions</Button>
        </div>
      </div>

      {/* User Stats */}
      <div className="grid grid-cols-1 md:grid-cols-5 gap-4 mb-6">
        {[0, 1, 2, 3, 4].map((tier) => (
          <StatsCard
            key={tier}
            title={`Tier ${tier} Users`}
            value={users?.tierDistribution?.[tier] || 0}
            icon={Shield}
          />
        ))}
      </div>

      {/* Filters */}
      <Card className="mb-6">
        <CardContent className="pt-6">
          <UserFilters 
            filters={filters} 
            onFiltersChange={setFilters} 
          />
        </CardContent>
      </Card>

      {/* Users Table */}
      <Card>
        <CardContent>
          <UsersDataTable
            users={users?.data || []}
            loading={isLoading}
            selectedUsers={selectedUsers}
            onSelectionChange={setSelectedUsers}
          />
        </CardContent>
      </Card>
    </div>
  );
}
```

#### **Day 3-4: User Profile Management**
```typescript
// components/users/user-profile-modal.tsx
export function UserProfileModal({ 
  userId, 
  isOpen, 
  onClose 
}: {
  userId: string;
  isOpen: boolean;
  onClose: () => void;
}) {
  const { data: user } = useQuery({
    queryKey: ['user', userId],
    queryFn: () => api.getUser(userId),
    enabled: isOpen
  });

  return (
    <Dialog open={isOpen} onOpenChange={onClose}>
      <DialogContent className="max-w-4xl">
        <DialogHeader>
          <DialogTitle>User Profile</DialogTitle>
        </DialogHeader>

        <Tabs defaultValue="overview">
          <TabsList>
            <TabsTrigger value="overview">Overview</TabsTrigger>
            <TabsTrigger value="investments">Investments</TabsTrigger>
            <TabsTrigger value="activity">Activity</TabsTrigger>
            <TabsTrigger value="compliance">Compliance</TabsTrigger>
          </TabsList>

          <TabsContent value="overview">
            <UserOverview user={user} />
          </TabsContent>

          <TabsContent value="investments">
            <UserInvestments userId={userId} />
          </TabsContent>

          <TabsContent value="activity">
            <UserActivity userId={userId} />
          </TabsContent>

          <TabsContent value="compliance">
            <UserCompliance userId={userId} />
          </TabsContent>
        </Tabs>
      </DialogContent>
    </Dialog>
  );
}
```

#### **Day 5: Bulk User Operations**
```typescript
// components/users/bulk-operations.tsx
export function BulkOperations({ 
  selectedUsers, 
  onComplete 
}: {
  selectedUsers: string[];
  onComplete: () => void;
}) {
  const [operation, setOperation] = useState<BulkOperation | null>(null);

  const { mutate: executeBulkOperation } = useMutation({
    mutationFn: ({ operation, userIds, data }: BulkOperationRequest) =>
      api.executeBulkOperation(operation, userIds, data),
    onSuccess: () => {
      toast({ title: 'Bulk operation completed successfully' });
      onComplete();
    }
  });

  const operations = [
    { id: 'tier-upgrade', name: 'Tier Upgrade', icon: ArrowUp },
    { id: 'suspend-accounts', name: 'Suspend Accounts', icon: Ban },
    { id: 'send-message', name: 'Send Message', icon: Mail },
    { id: 'export-data', name: 'Export Data', icon: Download }
  ];

  return (
    <Dialog open={!!operation} onOpenChange={() => setOperation(null)}>
      <div className="flex space-x-2">
        {operations.map((op) => (
          <Button
            key={op.id}
            variant="outline"
            onClick={() => setOperation(op)}
            disabled={selectedUsers.length === 0}
          >
            <op.icon className="w-4 h-4 mr-2" />
            {op.name}
          </Button>
        ))}
      </div>

      <DialogContent>
        <DialogHeader>
          <DialogTitle>{operation?.name}</DialogTitle>
        </DialogHeader>

        {operation && (
          <BulkOperationForm
            operation={operation}
            selectedUsers={selectedUsers}
            onSubmit={(data) => executeBulkOperation({
              operation: operation.id,
              userIds: selectedUsers,
              data
            })}
          />
        )}
      </DialogContent>
    </Dialog>
  );
}
```

### **Week 6: Analytics & Finalization**

#### **Day 1-2: Analytics Dashboard**
```typescript
// app/(dashboard)/analytics/page.tsx
export default function AnalyticsPage() {
  const [dateRange, setDateRange] = useState({
    from: subDays(new Date(), 30),
    to: new Date()
  });

  const { data: analytics } = useQuery({
    queryKey: ['analytics', dateRange],
    queryFn: () => api.getAnalytics(dateRange)
  });

  return (
    <div className="p-6">
      <div className="flex justify-between items-center mb-6">
        <h1 className="text-3xl font-bold">Analytics Dashboard</h1>
        <DateRangePicker
          value={dateRange}
          onChange={setDateRange}
        />
      </div>

      {/* Executive Summary */}
      <div className="grid grid-cols-1 md:grid-cols-4 gap-4 mb-8">
        <MetricCard
          title="Platform Revenue"
          value={formatCurrency(analytics?.revenue || 0)}
          change={analytics?.revenueChange}
          icon={DollarSign}
        />
        <MetricCard
          title="Total AUM"
          value={formatCurrency(analytics?.totalAum || 0)}
          change={analytics?.aumChange}
          icon={TrendingUp}
        />
        <MetricCard
          title="Active Users"
          value={analytics?.activeUsers || 0}
          change={analytics?.activeUsersChange}
          icon={Users}
        />
        <MetricCard
          title="Conversion Rate"
          value={`${analytics?.conversionRate || 0}%`}
          change={analytics?.conversionRateChange}
          icon={Target}
        />
      </div>

      {/* Charts Grid */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6 mb-8">
        <Card>
          <CardHeader>
            <CardTitle>Investment Volume Trends</CardTitle>
          </CardHeader>
          <CardContent>
            <InvestmentVolumeChart data={analytics?.volumeTrends} />
          </CardContent>
        </Card>

        <Card>
          <CardHeader>
            <CardTitle>User Acquisition</CardTitle>
          </CardHeader>
          <CardContent>
            <UserAcquisitionChart data={analytics?.userAcquisition} />
          </CardContent>
        </Card>

        <Card>
          <CardHeader>
            <CardTitle>Asset Performance</CardTitle>
          </CardHeader>
          <CardContent>
            <AssetPerformanceChart data={analytics?.assetPerformance} />
          </CardContent>
        </Card>

        <Card>
          <CardHeader>
            <CardTitle>Geographic Distribution</CardTitle>
          </CardHeader>
          <CardContent>
            <GeographicChart data={analytics?.geographic} />
          </CardContent>
        </Card>
      </div>

      {/* Detailed Tables */}
      <div className="space-y-6">
        <Card>
          <CardHeader>
            <CardTitle>Top Performing Assets</CardTitle>
          </CardHeader>
          <CardContent>
            <TopAssetsTable data={analytics?.topAssets} />
          </CardContent>
        </Card>

        <Card>
          <CardHeader>
            <CardTitle>User Engagement Metrics</CardTitle>
          </CardHeader>
          <CardContent>
            <EngagementMetricsTable data={analytics?.engagement} />
          </CardContent>
        </Card>
      </div>
    </div>
  );
}
```

#### **Day 3-4: Testing & Performance Optimization**
```typescript
// Performance Optimization Checklist

// 1. Code Splitting & Lazy Loading
const AssetManagement = lazy(() => import('./pages/AssetManagement'));
const KycManagement = lazy(() => import('./pages/KycManagement'));
const UserManagement = lazy(() => import('./pages/UserManagement'));

// 2. React Query Optimization
const queryClient = new QueryClient({
  defaultOptions: {
    queries: {
      staleTime: 5 * 60 * 1000, // 5 minutes
      cacheTime: 10 * 60 * 1000, // 10 minutes
      refetchOnWindowFocus: false,
      retry: 3
    }
  }
});

// 3. Virtual Scrolling for Large Tables
import { FixedSizeList as List } from 'react-window';

// 4. Image Optimization
import Image from 'next/image';

// 5. Bundle Analysis
npm run build
npm run analyze

// Testing Implementation
// tests/components/AssetManagement.test.tsx
describe('Asset Management', () => {
  test('renders asset list correctly', () => {
    render(<AssetManagement />);
    expect(screen.getByText('Asset Management')).toBeInTheDocument();
  });

  test('filters assets by type', async () => {
    render(<AssetManagement />);
    
    const typeFilter = screen.getByRole('combobox', { name: /type/i });
    await user.selectOptions(typeFilter, 'investment');
    
    await waitFor(() => {
      expect(screen.getByText('Investment Assets')).toBeInTheDocument();
    });
  });
});
```

#### **Day 5: Documentation & Deployment Prep**
```typescript
// Deployment Configuration
// next.config.js
const nextConfig = {
  output: 'standalone',
  env: {
    API_BASE_URL: process.env.API_BASE_URL,
    BLOCKCHAIN_NETWORK: process.env.BLOCKCHAIN_NETWORK
  },
  images: {
    domains: ['pend.storage', 'assets.pend.finance']
  }
};

// Docker Configuration
// Dockerfile
FROM node:18-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production
COPY . .
RUN npm run build

FROM node:18-alpine AS runner
WORKDIR /app
COPY --from=builder /app/.next/standalone ./
COPY --from=builder /app/.next/static ./.next/static
EXPOSE 3000
CMD ["node", "server.js"]

// Environment Variables Documentation
/*
REQUIRED:
- API_BASE_URL: Backend API URL
- NEXTAUTH_SECRET: JWT secret for authentication
- NEXTAUTH_URL: Admin panel URL

OPTIONAL:
- BLOCKCHAIN_NETWORK: 'testnet' | 'mainnet'
- SENTRY_DSN: Error tracking
- ANALYTICS_ID: Google Analytics
*/
```

## 🚀 **Deployment & Launch Plan**

### **Pre-launch Checklist**
- [ ] All components tested and working
- [ ] API integration complete and tested
- [ ] Authentication and authorization working
- [ ] Performance optimization complete
- [ ] Security audit completed
- [ ] Documentation updated
- [ ] Staging environment deployed and tested
- [ ] Production environment configured
- [ ] Monitoring and alerting set up
- [ ] Backup and recovery procedures tested

### **Launch Strategy**
1. **Soft Launch**: Deploy to staging with limited admin access
2. **User Acceptance Testing**: Test with key stakeholders
3. **Performance Testing**: Load testing with simulated traffic
4. **Security Review**: Final security audit and penetration testing
5. **Production Deployment**: Deploy to production environment
6. **Monitoring**: 24/7 monitoring for first week
7. **Feedback Collection**: Gather feedback and iterate

---

*This implementation plan provides a structured approach to building the Next.js admin panel with clear milestones, deliverables, and timelines for successful project completion.* 