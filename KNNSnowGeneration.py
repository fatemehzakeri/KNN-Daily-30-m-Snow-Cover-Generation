import numpy as np

# ================== SETTINGS ==================
# If True -> run only for the first query day (fast test)
# If False -> run for ALL query days
ONLY_FIRST_QUERY = False

# ------------------ PATHS ------------------
PATH_QUERY    = r"G:\QueryDates_converted.npz"
PATH_LEARN    = r"G:\LearningDates_converted.npz"
PATH_WEIGHTS  = r"G:\BayesResultXAtMinObjective_converted.npz"  # optional
OUT_PATH      = r"G:\ResultIndAll_python.npz"


# ------------------ VARIABLE ORDER ------------------
VAR_NAMES_FULL = [
    'Tmax-59', 'Tmin-59', 'P-59',
    'Tmax-58', 'Tmin-58', 'P-58',
    'Tmax-57', 'Tmin-57', 'P-57',
    'Tmax-56', 'Tmin-56', 'P-56',
    'Tmax-55', 'Tmin-55', 'P-55',
    'Tmax-54', 'Tmin-54', 'P-54',
    'Tmax-53', 'Tmin-53', 'P-53',
    'Tmax-52', 'Tmin-52', 'P-52',
    'Tmax-51', 'Tmin-51', 'P-51',
    'Tmax-50', 'Tmin-50', 'P-50',
    'Tmax-49', 'Tmin-49', 'P-49',
    'Tmax-48', 'Tmin-48', 'P-48',
    'Tmax-47', 'Tmin-47', 'P-47',
    'Tmax-46', 'Tmin-46', 'P-46',
    'Tmax-45', 'Tmin-45', 'P-45',
    'Tmax-44', 'Tmin-44', 'P-44',
    'Tmax-43', 'Tmin-43', 'P-43',
    'Tmax-42', 'Tmin-42', 'P-42',
    'Tmax-41', 'Tmin-41', 'P-41',
    'Tmax-40', 'Tmin-40', 'P-40',
    'Tmax-39', 'Tmin-39', 'P-39',
    'Tmax-38', 'Tmin-38', 'P-38',
    'Tmax-37', 'Tmin-37', 'P-37',
    'Tmax-36', 'Tmin-36', 'P-36',
    'Tmax-35', 'Tmin-35', 'P-35',
    'Tmax-34', 'Tmin-34', 'P-34',
    'Tmax-33', 'Tmin-33', 'P-33',
    'Tmax-32', 'Tmin-32', 'P-32',
    'Tmax-31', 'Tmin-31', 'P-31',
    'Tmax-30', 'Tmin-30', 'P-30',
    'Tmax-29', 'Tmin-29', 'P-29',
    'Tmax-28', 'Tmin-28', 'P-28',
    'Tmax-27', 'Tmin-27', 'P-27',
    'Tmax-26', 'Tmin-26', 'P-26',
    'Tmax-25', 'Tmin-25', 'P-25',
    'Tmax-24', 'Tmin-24', 'P-24',
    'Tmax-23', 'Tmin-23', 'P-23',
    'Tmax-22', 'Tmin-22', 'P-22',
    'Tmax-21', 'Tmin-21', 'P-21',
    'Tmax-20', 'Tmin-20', 'P-20',
    'Tmax-19', 'Tmin-19', 'P-19',
    'Tmax-18', 'Tmin-18', 'P-18',
    'Tmax-17', 'Tmin-17', 'P-17',
    'Tmax-16', 'Tmin-16', 'P-16',
    'Tmax-15', 'Tmin-15', 'P-15',
    'Tmax-14', 'Tmin-14', 'P-14',
    'Tmax-13', 'Tmin-13', 'P-13',
    'Tmax-12', 'Tmin-12', 'P-12',
    'Tmax-11', 'Tmin-11', 'P-11',
    'Tmax-10', 'Tmin-10', 'P-10',
    'Tmax-9',  'Tmin-9',  'P-9',
    'Tmax-8',  'Tmin-8',  'P-8',
    'Tmax-7',  'Tmin-7',  'P-7',
    'Tmax-6',  'Tmin-6',  'P-6',
    'Tmax-5',  'Tmin-5',  'P-5',
    'Tmax-4',  'Tmin-4',  'P-4',
    'Tmax-3',  'Tmin-3',  'P-3',
    'Tmax-2',  'Tmin-2',  'P-2',
    'Tmax-1',  'Tmin-1',  'P-1',
    'Tmax', 'Tmin', 'P',
    'MODIS', 'MYD', 'Shadow', 'LandsatClosest'
]

M_full = len(VAR_NAMES_FULL)
print("Full variable count:", M_full)

# LandsatTru (LearningDates) ↔ LandsatClosest (QueryDates)
NAME_MAP_LEARN_TO_QUERY = {"LandsatTru": "LandsatClosest"}
reverse_map = {v: k for k, v in NAME_MAP_LEARN_TO_QUERY.items()}

# ------------------ LOAD TABLES ------------------
qd_npz = np.load(PATH_QUERY, allow_pickle=True)
ld_npz = np.load(PATH_LEARN, allow_pickle=True)

qd_dates = qd_npz["Dates"]
ld_dates = ld_npz["Dates"]
NQ = qd_dates.shape[0]
NL = ld_dates.shape[0]

print("NQ (QueryDates rows):", NQ)
print("NL (LearningDates rows):", NL)

qd_keys = set(qd_npz.files); qd_keys.discard("Dates")
ld_keys = set(ld_npz.files); ld_keys.discard("Dates")

# ------------------ WHICH VARIABLES ARE AVAILABLE IN BOTH ------------------
VAR_NAMES_USED = []
for name in VAR_NAMES_FULL:
    learn_name = reverse_map.get(name, name)
    if name in qd_keys and learn_name in ld_keys:
        VAR_NAMES_USED.append(name)

print("Variables used:", len(VAR_NAMES_USED))
if len(VAR_NAMES_USED) == 0:
    raise RuntimeError("No common variables between QueryDates and LearningDates!")

# ------------------ LOAD WEIGHTS ------------------
try:
    w_npz = np.load(PATH_WEIGHTS, allow_pickle=True)

    def get_w(name, default=1.0):
        if name in w_npz.files:
            return float(w_npz[name])
        print(f"  Warning: weight '{name}' not found, using {default}")
        return float(default)

    wCloseAggreTmax   = get_w("wCloseAggreTmax")
    wCloseAggreTmin   = get_w("wCloseAggreTmin")
    wCloseAggreP      = get_w("wCloseAggreP")
    wTmax             = get_w("wTmax")
    wTmin             = get_w("wTmin")
    wP                = get_w("wP")
    wMODIS            = get_w("wMODIS")
    wMYD              = get_w("wMYD")
    wShadow           = get_w("wShadow")
    wClosestLandsat   = get_w("wClosestLandsat")
except FileNotFoundError:
    print("Weights file not found – using all weights = 1.")
    wCloseAggreTmax = wCloseAggreTmin = wCloseAggreP = 1.0
    wTmax = wTmin = wP = 1.0
    wMODIS = wMYD = wShadow = wClosestLandsat = 1.0

# ------------------ BUILD WEIGHT VECTOR ------------------
w_full = np.zeros(M_full, dtype=float)

# Long temporal neighbourhood (Tmax/Tmin/P long)
w_full[0:165:3] = wTmax   # 1,4,7,...,163
w_full[1:165:3] = wTmin   # 2,5,8,...,164
w_full[2:165:3] = wP      # 3,6,9,...,165

# Short temporal neighbourhood (CloseAggre)
w_full[165:178:3] = wCloseAggreTmax  # 166,169,...,178
w_full[166:179:3] = wCloseAggreTmin  # 167,170,...,179
w_full[167:180:3] = wCloseAggreP     # 168,171,...,180

# MODIS, MYD, Shadow, Closest Landsat
w_full[180] = wMODIS
w_full[181] = wMYD
w_full[182] = wShadow
w_full[183] = wClosestLandsat

name_to_index_full = {name: idx for idx, name in enumerate(VAR_NAMES_FULL)}

# Restrict weights to variables we actually use
w_vec = np.zeros(len(VAR_NAMES_USED), dtype=float)
for j, name in enumerate(VAR_NAMES_USED):
    w_vec[j] = w_full[name_to_index_full[name]]

sw = w_vec.sum()
if sw == 0:
    print("Warning: sum of weights is zero – using uniform weights.")
    w_vec[:] = 1.0 / len(VAR_NAMES_USED)
else:
    w_vec /= sw

print("Sum of weights (w_vec):", w_vec.sum())

# ================== KNN DISTANCE COMPUTATION ==================

if ONLY_FIRST_QUERY:
    q_indices = np.array([0], dtype=int)
else:
    q_indices = np.arange(NQ, dtype=int)

NQ_eff = len(q_indices)
print("Computing KNN for", NQ_eff, "query days")

ResultIndAll   = np.zeros((NQ_eff, NL + 1), dtype=np.int64)
ErrorMean_out  = np.zeros((NQ_eff, NL + 1), dtype=float)
ErrorSTD_out   = np.zeros((NQ_eff, NL + 1), dtype=float)

for idx_q, i in enumerate(q_indices):
    qdate = int(qd_dates[i])
    print(f"\n=== Query index {i} (date {qdate}) ===")

    # distance for this query
    dist_mean = np.zeros(NL, dtype=float)
    dist_std  = np.zeros(NL, dtype=float)

    for j, name in enumerate(VAR_NAMES_USED):
        learn_name = reverse_map.get(name, name)

        A_all = qd_npz[name].astype(np.float64)        # (NQ, H, W)
        B     = ld_npz[learn_name].astype(np.float64)  # (NL, H, W)

        Ai = A_all[i]   # (H, W)

        # check
        if Ai.shape != B[0].shape:
            raise ValueError(
                f"Shape mismatch for {name}/{learn_name}: "
                f"query {Ai.shape}, learning {B[0].shape}"
            )

        wj = w_vec[j]

        # vectorize across all learning dates (NL)
        diff = np.abs(B - Ai[None, ...])      # (NL, H, W)
        mean_k = np.nanmean(diff, axis=(1, 2))  # (NL,)
        std_k  = np.nanstd(diff, axis=(1, 2))   # (NL,)

        # replace NaNs with 0 
        mean_k = np.where(np.isnan(mean_k), 0.0, mean_k)
        std_k  = np.where(np.isnan(std_k), 0.0, std_k)

        dist_mean += mean_k * wj
        dist_std  += std_k * wj

    # sort distances 
    order = np.argsort(dist_mean)
    sorted_ld_dates = ld_dates[order]

    ResultIndAll[idx_q, 0]   = qdate
    ResultIndAll[idx_q, 1:]  = sorted_ld_dates

    ErrorMean_out[idx_q, 0]  = qdate
    ErrorMean_out[idx_q, 1:] = dist_mean[order]

    ErrorSTD_out[idx_q, 0]   = qdate
    ErrorSTD_out[idx_q, 1:]  = dist_std[order]

    # For quick check: show top 10 for this query
    print("Top 10 learning dates for this query:")
    print(sorted_ld_dates[:10])


# ================== SAVE RESULTS ==================

np.savez(
    OUT_PATH,
    ResultIndAll=ResultIndAll,
    ErrorMean=ErrorMean_out,
    ErrorSTD=ErrorSTD_out,
)

print("\nSaved:", OUT_PATH)
print("ResultIndAll shape:", ResultIndAll.shape)
print("ErrorMean shape:", ErrorMean_out.shape)
print("ErrorSTD shape:", ErrorSTD_out.shape)

print(ResultIndAll[0, :10])
